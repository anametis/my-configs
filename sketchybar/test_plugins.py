#!/usr/bin/env python3
"""Run with python3 test_plugins.py. Uses fake device data, never changes the bar."""
import os
from pathlib import Path
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent
with tempfile.TemporaryDirectory() as tmp:
    temp = Path(tmp)
    log = temp / 'calls'
    bar = temp / 'sketchybar'
    bar.write_text('#!/bin/bash\nprintf "%s\\0" "$@" >> "$CALLS"\nexit "${BAR_EXIT:-0}"\n')
    bar.chmod(0o700)
    aero = temp / 'aerospace'
    aero.write_text('''#!/bin/bash
case "$1 $2" in
  workspace\\ *) printf '%s' "$2" > "$WORKSPACE_CALL"; exit "${WORKSPACE_EXIT:-0}" ;;
  'list-workspaces --all') printf '1\\037true\\037true\\0371\\n6\\037false\\037true\\0372\\n' ;;
  'list-windows --all') printf '1\\0371\\037Code\\037com.microsoft.VSCode\\n1\\0372\\037Code\\037com.microsoft.VSCode\\n' ;;
  'list-windows --focused') printf '1\\037Code\\037com.microsoft.VSCode\\0371\\n' ;;
esac
''')
    aero.chmod(0o700)
    mocks = temp / 'mocks'
    mocks.write_text('''function /usr/bin/pmset() { printf '%s\\n' "$BATTERY_STATE"; }
function /usr/bin/osascript() { printf '%s\\n' "$VOLUME_STATE"; return "${VOLUME_EXIT:-0}"; }
function /usr/sbin/networksetup() {
  case "$1" in
    -listallhardwareports) printf 'Hardware Port: Wi-Fi\\nDevice: en0\\n' ;;
    -getairportpower) echo 'Wi-Fi Power (en0): On' ;;
    -getairportnetwork) echo 'You are not associated with an AirPort network.' ;;
  esac
}
function /usr/sbin/ipconfig() { printf '%s\\n' "${WIFI_IP:-}"; }
function /sbin/ifconfig() { printf 'status: %s\\n' "${WIFI_STATUS:-inactive}"; }
''')
    renderer = temp / 'app-strip'
    subprocess.run(['/usr/bin/swiftc', '-O', str(ROOT / 'helpers/app_strip.swift'),
                    '-o', str(renderer)], check=True, capture_output=True)
    env = {**os.environ, 'CONFIG_DIR': str(ROOT), 'TMPDIR': tmp,
           'SKETCHYBAR_BIN': str(bar), 'AEROSPACE_BIN': str(aero),
           'APP_STRIP_BIN': str(renderer), 'APP_STRIP_CACHE': tmp,
           'CALLS': str(log), 'BASH_ENV': str(mocks),
           'WORKSPACE_CALL': str(temp / 'workspace')}
    for key in ('NAME', 'INFO', 'SENDER', 'SHOW_DUPLICATE_WINDOWS', 'MAX_APP_ICONS'):
        env.pop(key, None)

    def run(plugin, *args, **values):
        log.write_bytes(b'')
        result = subprocess.run(['/bin/bash', str(ROOT / 'plugins' / plugin), *args],
                                env={**env, **values}, capture_output=True, timeout=10)
        return result.returncode, log.read_bytes().decode().split('\0')[:-1]

    def item(args, name):
        start = args.index(name) + 1
        end = args.index('--set', start) if '--set' in args[start:] else len(args)
        return args[start:end]

    _, charging = run('battery.sh', BATTERY_STATE="Now drawing from 'AC Power'\n80%; charging; 0:20 remaining")
    _, held = run('battery.sh', BATTERY_STATE="Now drawing from 'AC Power'\n80%; AC attached; not charging present: true")
    assert next(x for x in charging if x.startswith('icon=')) != next(x for x in held if x.startswith('icon='))
    _, low = run('battery.sh', BATTERY_STATE='9%; discharging; 0:10 remaining')
    assert 'icon.color=0xffee8e8e' in low and 'label=9%' in low
    assert 'drawing=off' in run('battery.sh', BATTERY_STATE='No batteries')[1]
    _, muted = run('volume.sh', INFO='51', VOLUME_STATE='51|true')
    _, audible = run('volume.sh', INFO='51', VOLUME_STATE='51|false')
    assert next(x for x in muted if x.startswith('icon=')) != next(x for x in audible if x.startswith('icon='))
    assert 'label=51%' in muted
    assert not run('volume.sh', VOLUME_STATE='', VOLUME_EXIT='1')[1]
    assert not run('volume.sh', VOLUME_STATE='invalid|false')[1]

    _, disconnected = run('wifi.sh')
    _, connected = run('wifi.sh', WIFI_IP='192.0.2.1', WIFI_STATUS='active')
    assert next(x for x in disconnected if x.startswith('icon=')) != next(x for x in connected if x.startswith('icon='))

    code, args = run('aerospace_refresh.sh', '--force')
    assert code == 0, code
    assert 'display=1' in item(args, 'aerospace.space.1')
    assert 'display=2' in item(args, 'aerospace.space.6')
    assert 'label.width=28' in item(args, 'aerospace.space.1'), 'Duplicate app shown'
    assert 'label.background.image.drawing=on' in item(args, 'aerospace.space.1')
    strip = next(x.split('=', 1)[1] for x in item(args, 'aerospace.space.1') if x.startswith('label.background.image='))
    import struct
    assert struct.unpack('>II', Path(strip).read_bytes()[16:24]) == (56, 44)
    assert Path(strip).stat().st_size > 1000, 'Icon strip is blank'
    cached_mtime = Path(strip).stat().st_mtime_ns
    run('aerospace_refresh.sh', '--force')
    assert Path(strip).stat().st_mtime_ns == cached_mtime, 'Cached strip was regenerated'
    assert 'background.drawing=on' in item(args, 'aerospace.space.1')
    assert not any(x.startswith(('aerospace.app.', 'aerospace.group.', 'aerospace.spaces.')) for x in args)
    assert 'drawing=off' in item(args, 'aerospace.space.9'), 'Missing workspace stays visible'
    assert '--reorder' not in args and '--bar' not in args
    assert not run('aerospace_refresh.sh')[1], 'Unchanged state redrawn'
    assert not run('aerospace_click.sh', '1')[1], 'Click still repairs stacking'
    assert (temp / 'workspace').read_text() == '1'
    assert run('aerospace_click.sh', '6', WORKSPACE_EXIT='1')[0] == 1
    assert (temp / 'workspace').read_text() == '6'
    log.write_bytes(b'')
    subprocess.run(['/bin/bash', '-c',
        'source "$CONFIG_DIR/settings.sh"; source "$CONFIG_DIR/colors.sh"; source "$CONFIG_DIR/items/aerospace_workspaces.sh"'],
        env=env, check=True)
    construction = log.read_bytes().decode().split('\0')[:-1]
    assert 'bracket' not in construction, 'Workspace backgrounds must share their content window'
    assert construction.count('--add') == 10, 'Expected nine capsules and one hidden watcher'
    for workspace in range(1, 10):
        assert f"click_script='{ROOT}/plugins/aerospace_click.sh' '{workspace}'" in construction

    assert run('aerospace_click.sh', 'invalid')[0] != 0
    assert 'label.background.drawing=on' in construction
    assert run('aerospace_refresh.sh', SENDER='system_woke')[1]
    assert run('aerospace_refresh.sh', SENDER='display_change')[1]
    _, args = run('aerospace_refresh.sh', '--force', SHOW_DUPLICATE_WINDOWS='true', MAX_APP_ICONS='1')
    assert 'label.width=52' in item(args, 'aerospace.space.1')
    hash_file = temp / f'sketchybar-aerospace-{os.getuid()}.hash'
    hash_file.unlink()
    assert run('aerospace_refresh.sh', BAR_EXIT='1')[0] != 0
    assert not hash_file.exists(), 'Failed render was cached'
    assert run('aerospace_refresh.sh')[1], 'Failed render was not retried'

    # A kernel lock must survive the lockf subprocess, then release with its owner.
    lock = temp / f'sketchybar-aerospace-{os.getuid()}.lockfile'
    owner = subprocess.Popen(['/bin/bash', '-c',
        'exec 9>"$1"; /usr/bin/lockf -s -t 0 9 || exit; echo locked; read -r',
        'test', str(lock)], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True)
    try:
        assert owner.stdout.readline().strip() == 'locked'
        blocked = subprocess.run(['/usr/bin/lockf', '-k', '-s', '-t', '0', str(lock), '/usr/bin/true'])
        assert blocked.returncode != 0, 'Lock released before refresh finished'
    finally:
        owner.kill()
        owner.wait()
        owner.stdin.close()
        owner.stdout.close()
    assert run('aerospace_refresh.sh', '--force')[0] == 0, 'Dead owner left a stale lock'

print('Plugin checks passed: battery, mute, Wi-Fi, display mapping, deduplication, overflow, cache retry, lock recovery.')
