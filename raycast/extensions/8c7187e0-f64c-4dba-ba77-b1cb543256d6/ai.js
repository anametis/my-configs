"use strict";var ye=Object.create;var U=Object.defineProperty;var ke=Object.getOwnPropertyDescriptor;var we=Object.getOwnPropertyNames;var xe=Object.getPrototypeOf,ve=Object.prototype.hasOwnProperty;var Se=(r,n)=>{for(var e in n)U(r,e,{get:n[e],enumerable:!0})},ee=(r,n,e,t)=>{if(n&&typeof n=="object"||typeof n=="function")for(let a of we(n))!ve.call(r,a)&&a!==e&&U(r,a,{get:()=>n[a],enumerable:!(t=ke(n,a))||t.enumerable});return r};var w=(r,n,e)=>(e=r!=null?ye(xe(r)):{},ee(n||!r||!r.__esModule?U(e,"default",{value:r,enumerable:!0}):e,r)),Ee=r=>ee(U({},"__esModule",{value:!0}),r);var De={};Se(De,{default:()=>Le});module.exports=Ee(De);var g=require("@raycast/api");var S=w(require("react")),d=require("@raycast/api");var v=w(require("node:fs")),x=w(require("node:path")),ie=w(require("node:crypto")),P=w(require("node:child_process")),oe=require("node:buffer"),E=w(require("node:stream")),ce=require("node:util"),m=require("node:fs/promises");var le=require("react/jsx-runtime"),J=w(require("node:os"));var F=globalThis;function z(r,n){let e=r instanceof Error?r.message:String(r);return(0,d.showToast)({style:d.Toast.Style.Failure,title:n?.title??"Something went wrong",message:n?.message??e,primaryAction:n?.primaryAction??te(r),secondaryAction:n?.primaryAction?te(r):void 0})}var te=r=>{let n=!0,e="[Extension Name]...",t="";try{let s=JSON.parse((0,v.readFileSync)((0,x.join)(d.environment.assetsPath,"..","package.json"),"utf8"));e=`[${s.title}]...`,t=`https://raycast.com/${s.owner||s.author}/${s.name}`,(!s.owner||s.access==="public")&&(n=!1)}catch{}let a=d.environment.isDevelopment||n,i=r instanceof Error?r?.stack||r?.message||"":String(r);return{title:a?"Copy Logs":"Report Error",onAction(s){s.hide(),a?d.Clipboard.copy(i):(0,d.open)(`https://github.com/raycast/extensions/issues/new?&labels=extension%2Cbug&template=extension_bug_report.yml&title=${encodeURIComponent(e)}&extension-url=${encodeURI(t)}&description=${encodeURIComponent(`#### Error:
\`\`\`
${i}
\`\`\`
`)}`)}}};function re(r){return typeof r!="function"?!1:/^function\s+\w*\s*\(\s*\)\s*{\s+\[native code\]\s+}$/i.exec(Function.prototype.toString.call(r))!==null}function Ae(r){return r instanceof URLSearchParams?r.toString():r}function ue(r,n=[]){function e(t){return"update"in r?r.update(t,"utf8"):r.write(t)}return{dispatch:function(t){t=Ae(t),t===null?this._null():this["_"+typeof t](t)},_object:function(t){let a=/\[object (.*)\]/i,i=Object.prototype.toString.call(t),s=a.exec(i)?.[1]??"unknown:["+i+"]";s=s.toLowerCase();let o=null;if((o=n.indexOf(t))>=0){this.dispatch("[CIRCULAR:"+o+"]");return}else n.push(t);if(Buffer.isBuffer(t))return e("buffer:"),e(t.toString("utf8"));if(s!=="object"&&s!=="function"&&s!=="asyncfunction")if(this["_"+s])this["_"+s](t);else throw new Error('Unknown object type "'+s+'"');else{let c=Object.keys(t);c=c.sort(),re(t)||c.splice(0,0,"prototype","__proto__","constructor"),e("object:"+c.length+":");let l=this;return c.forEach(function(u){l.dispatch(u),e(":"),l.dispatch(t[u]),e(",")})}},_array:function(t,a){a=typeof a<"u"?a:!1;let i=this;if(e("array:"+t.length+":"),!a||t.length<=1){t.forEach(function(c){i.dispatch(c)});return}let s=[],o=t.map(function(c){let l=Te(),u=n.slice();return ue(l,u).dispatch(c),s=s.concat(u.slice(n.length)),l.read().toString()});n=n.concat(s),o.sort(),this._array(o,!1)},_date:function(t){e("date:"+t.toJSON())},_symbol:function(t){e("symbol:"+t.toString())},_error:function(t){e("error:"+t.toString())},_boolean:function(t){e("bool:"+t.toString())},_string:function(t){e("string:"+t.length+":"),e(t.toString())},_function:function(t){e("fn:"),re(t)?this.dispatch("[native]"):this.dispatch(t.toString()),this.dispatch("function-name:"+String(t.name)),this._object(t)},_number:function(t){e("number:"+t.toString())},_xml:function(t){e("xml:"+t.toString())},_null:function(){e("Null")},_undefined:function(){e("Undefined")},_regexp:function(t){e("regex:"+t.toString())},_uint8array:function(t){e("uint8array:"),this.dispatch(Array.prototype.slice.call(t))},_uint8clampedarray:function(t){e("uint8clampedarray:"),this.dispatch(Array.prototype.slice.call(t))},_int8array:function(t){e("int8array:"),this.dispatch(Array.prototype.slice.call(t))},_uint16array:function(t){e("uint16array:"),this.dispatch(Array.prototype.slice.call(t))},_int16array:function(t){e("int16array:"),this.dispatch(Array.prototype.slice.call(t))},_uint32array:function(t){e("uint32array:"),this.dispatch(Array.prototype.slice.call(t))},_int32array:function(t){e("int32array:"),this.dispatch(Array.prototype.slice.call(t))},_float32array:function(t){e("float32array:"),this.dispatch(Array.prototype.slice.call(t))},_float64array:function(t){e("float64array:"),this.dispatch(Array.prototype.slice.call(t))},_arraybuffer:function(t){e("arraybuffer:"),this.dispatch(new Uint8Array(t))},_url:function(t){e("url:"+t.toString())},_map:function(t){e("map:");let a=Array.from(t);this._array(a,!0)},_set:function(t){e("set:");let a=Array.from(t);this._array(a,!0)},_file:function(t){e("file:"),this.dispatch([t.name,t.size,t.type,t.lastModified])},_blob:function(){throw Error(`Hashing Blob objects is currently not supported
(see https://github.com/puleos/object-hash/issues/26)
Use "options.replacer" or "options.ignoreUnknown"
`)},_domwindow:function(){e("domwindow")},_bigint:function(t){e("bigint:"+t.toString())},_process:function(){e("process")},_timer:function(){e("timer")},_pipe:function(){e("pipe")},_tcp:function(){e("tcp")},_udp:function(){e("udp")},_tty:function(){e("tty")},_statwatcher:function(){e("statwatcher")},_securecontext:function(){e("securecontext")},_connection:function(){e("connection")},_zlib:function(){e("zlib")},_context:function(){e("context")},_nodescript:function(){e("nodescript")},_httpparser:function(){e("httpparser")},_dataview:function(){e("dataview")},_signal:function(){e("signal")},_fsevent:function(){e("fsevent")},_tlswrap:function(){e("tlswrap")}}}function Te(){return{buf:"",write:function(r){this.buf+=r},end:function(r){this.buf+=r},read:function(){return this.buf}}}function fe(r){let n=ie.default.createHash("sha1");return ue(n).dispatch(r),n.digest("hex")}var C=r=>!!r&&typeof r=="object"&&typeof r.removeListener=="function"&&typeof r.emit=="function"&&typeof r.reallyExit=="function"&&typeof r.listeners=="function"&&typeof r.kill=="function"&&typeof r.pid=="number"&&typeof r.on=="function",M=Symbol.for("signal-exit emitter"),V=class{constructor(){if(this.emitted={afterExit:!1,exit:!1},this.listeners={afterExit:[],exit:[]},this.count=0,this.id=Math.random(),F[M])return F[M];Object.defineProperty(F,M,{value:this,writable:!1,enumerable:!1,configurable:!1})}on(n,e){this.listeners[n].push(e)}removeListener(n,e){let t=this.listeners[n],a=t.indexOf(e);a!==-1&&(a===0&&t.length===1?t.length=0:t.splice(a,1))}emit(n,e,t){if(this.emitted[n])return!1;this.emitted[n]=!0;let a=!1;for(let i of this.listeners[n])a=i(e,t)===!0||a;return n==="exit"&&(a=this.emit("afterExit",e,t)||a),a}},j=class{onExit(){return()=>{}}load(){}unload(){}},B=class{#o;#t;#e;#s;#i;#a;#n;#r;constructor(n){this.#o=process.platform==="win32"?"SIGINT":"SIGHUP",this.#t=new V,this.#a={},this.#n=!1,this.#r=[],this.#r.push("SIGHUP","SIGINT","SIGTERM"),globalThis.process.platform!=="win32"&&this.#r.push("SIGALRM","SIGABRT","SIGVTALRM","SIGXCPU","SIGXFSZ","SIGUSR2","SIGTRAP","SIGSYS","SIGQUIT","SIGIOT"),globalThis.process.platform==="linux"&&this.#r.push("SIGIO","SIGPOLL","SIGPWR","SIGSTKFLT"),this.#e=n,this.#a={};for(let e of this.#r)this.#a[e]=()=>{let t=this.#e.listeners(e),{count:a}=this.#t,i=n;if(typeof i.__signal_exit_emitter__=="object"&&typeof i.__signal_exit_emitter__.count=="number"&&(a+=i.__signal_exit_emitter__.count),t.length===a){this.unload();let s=this.#t.emit("exit",null,e),o=e==="SIGHUP"?this.#o:e;s||n.kill(n.pid,o)}};this.#i=n.reallyExit,this.#s=n.emit}onExit(n,e){if(!C(this.#e))return()=>{};this.#n===!1&&this.load();let t=e?.alwaysLast?"afterExit":"exit";return this.#t.on(t,n),()=>{this.#t.removeListener(t,n),this.#t.listeners.exit.length===0&&this.#t.listeners.afterExit.length===0&&this.unload()}}load(){if(!this.#n){this.#n=!0,this.#t.count+=1;for(let n of this.#r)try{let e=this.#a[n];e&&this.#e.on(n,e)}catch{}this.#e.emit=(n,...e)=>this.#l(n,...e),this.#e.reallyExit=n=>this.#c(n)}}unload(){this.#n&&(this.#n=!1,this.#r.forEach(n=>{let e=this.#a[n];if(!e)throw new Error("Listener not defined for signal: "+n);try{this.#e.removeListener(n,e)}catch{}}),this.#e.emit=this.#s,this.#e.reallyExit=this.#i,this.#t.count-=1)}#c(n){return C(this.#e)?(this.#e.exitCode=n||0,this.#t.emit("exit",this.#e.exitCode,null),this.#i.call(this.#e,this.#e.exitCode)):0}#l(n,...e){let t=this.#s;if(n==="exit"&&C(this.#e)){typeof e[0]=="number"&&(this.#e.exitCode=e[0]);let a=t.call(this.#e,n,...e);return this.#t.emit("exit",this.#e.exitCode,null),a}else return t.call(this.#e,n,...e)}},W=null,Re=(r,n)=>(W||(W=C(process)?new B(process):new j),W.onExit(r,n));function G(r,{timeout:n}={}){let e=new Promise((o,c)=>{r.on("exit",(l,u)=>{o({exitCode:l,signal:u,timedOut:!1})}),r.on("error",l=>{c(l)}),r.stdin&&r.stdin.on("error",l=>{c(l)})}),t=Re(()=>{r.kill()});if(n===0||n===void 0)return e.finally(()=>t());let a,i=new Promise((o,c)=>{a=setTimeout(()=>{r.kill("SIGTERM"),c(Object.assign(new Error("Timed out"),{timedOut:!0,signal:"SIGTERM"}))},n)}),s=e.finally(()=>{clearTimeout(a)});return Promise.race([i,s]).finally(()=>t())}var H=class extends Error{constructor(){super("The output is too big"),this.name="MaxBufferError"}};function Ne(r){let{encoding:n}=r,e=n==="buffer",t=new E.default.PassThrough({objectMode:!1});n&&n!=="buffer"&&t.setEncoding(n);let a=0,i=[];return t.on("data",s=>{i.push(s),a+=s.length}),t.getBufferedValue=()=>e?Buffer.concat(i,a):i.join(""),t.getBufferedLength=()=>a,t}async function ne(r,n){let e=Ne(n);return await new Promise((t,a)=>{let i=s=>{s&&e.getBufferedLength()<=oe.constants.MAX_LENGTH&&(s.bufferedData=e.getBufferedValue()),a(s)};(async()=>{try{await(0,ce.promisify)(E.default.pipeline)(r,e),t()}catch(s){i(s)}})(),e.on("data",()=>{e.getBufferedLength()>8e7&&i(new H)})}),e.getBufferedValue()}async function ae(r,n){r.destroy();try{return await n}catch(e){return e.bufferedData}}async function K({stdout:r,stderr:n},{encoding:e},t){let a=ne(r,{encoding:e}),i=ne(n,{encoding:e});try{return await Promise.all([t,a,i])}catch(s){return Promise.all([{error:s,exitCode:null,signal:s.signal,timedOut:s.timedOut||!1},ae(r,a),ae(n,i)])}}function _e(r){let n=typeof r=="string"?`
`:10,e=typeof r=="string"?"\r":13;return r[r.length-1]===n&&(r=r.slice(0,-1)),r[r.length-1]===e&&(r=r.slice(0,-1)),r}function se(r,n){return r.stripFinalNewline?_e(n):n}function Ie({timedOut:r,timeout:n,signal:e,exitCode:t}){return r?`timed out after ${n} milliseconds`:e!=null?`was killed with ${e}`:t!=null?`failed with exit code ${t}`:"failed"}function Ue({stdout:r,stderr:n,error:e,signal:t,exitCode:a,command:i,timedOut:s,options:o,parentError:c}){let u=`Command ${Ie({timedOut:s,timeout:o?.timeout,signal:t,exitCode:a})}: ${i}`,h=e?`${u}
${e.message}`:u,k=[h,n,r].filter(Boolean).join(`
`);return e?e.originalMessage=e.message:e=c,e.message=k,e.shortMessage=h,e.command=i,e.exitCode=a,e.signal=t,e.stdout=r,e.stderr=n,"bufferedData"in e&&delete e.bufferedData,e}function Ce({stdout:r,stderr:n,error:e,exitCode:t,signal:a,timedOut:i,command:s,options:o,parentError:c}){if(e||t!==0||a!==null)throw Ue({error:e,exitCode:t,signal:a,stdout:r,stderr:n,command:s,timedOut:i,options:o,parentError:c});return r}var O=class extends Error{constructor(n){super(n),this.name="PermissionError"}};async function Pe(r,n,e){if(!(0,v.existsSync)(r))throw new Error("The database does not exist");let t;try{t=await(o=>import(o))("node:sqlite")}catch{return Oe(r,n,e)}let a=new t.DatabaseSync(r,{open:!1,readOnly:!0}),i=e?.signal;try{a.open();let s=a.prepare(n);y(i);let o=s.all();return a.close(),o}catch(s){if(s.errcode===5||s.errcode===14||s.message.match("(5)")||s.message.match("(14)")){let o;if(!o){let u=x.default.join(J.default.tmpdir(),"useSQL",fe(r));await(0,m.mkdir)(u,{recursive:!0}),y(i),o=x.default.join(u,"db.db");try{await(0,m.copyFile)(r,o)}catch(h){throw process.platform==="darwin"&&h.code==="EPERM"?new O("You do not have permission to access the database."):h}await(0,m.writeFile)(o+"-shm",""),await(0,m.writeFile)(o+"-wal",""),y(i)}a=new t.DatabaseSync(o,{open:!1,readOnly:!0}),a.open(),y(i);let c=a.prepare(n);y(i);let l=c.all();return a.close(),l}throw s}}async function Oe(r,n,e){let t=e?.signal,a=P.default.spawn("sqlite3",["--json","--readonly",r,n],{signal:t}),i=G(a),[{error:s,exitCode:o,signal:c},l,u]=await K(a,{encoding:"utf-8"},i);if(y(t),u.match("(5)")||u.match("(14)")){let h;if(!h){let k=x.default.join(J.default.tmpdir(),"useSQL",fe(r));await(0,m.mkdir)(k,{recursive:!0}),y(t),h=x.default.join(k,"db.db"),await(0,m.copyFile)(r,h),await(0,m.writeFile)(h+"-shm",""),await(0,m.writeFile)(h+"-wal",""),y(t)}a=P.default.spawn("sqlite3",["--json","--readonly","--vfs","unix-none",h,n],{signal:t}),i=G(a),[{error:s,exitCode:o,signal:c},l,u]=await K(a,{encoding:"utf-8"},i),y(t)}if(s||o!==0||c!==null)throw process.platform==="darwin"&&u.includes("authorization denied")?new O("You do not have permission to access the database."):new Error(u||"Unknown error");return JSON.parse(l.trim()||"[]")}function y(r){if(r?.aborted){let n=new Error("aborted");throw n.name="AbortError",n}}var je=!!process.env.RAYCASTX;function A(r,n){return Pe(r,n)}async function Z(r,n,e){if(process.platform!=="darwin")throw new Error("AppleScript is only supported on macOS");let{humanReadableOutput:t,language:a,timeout:i,...s}=Array.isArray(n)?e||{}:n||{},o=t!==!1?[]:["-ss"];a==="JavaScript"&&o.push("-l","JavaScript"),Array.isArray(n)&&o.push("-",...n);let c=P.default.spawn("osascript",o,{...s,env:{PATH:"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"}}),l=G(c,{timeout:i??1e4});c.stdin.end(r);let[{error:u,exitCode:h,signal:k,timedOut:_},I,b]=await K(c,{encoding:"utf8"},l),f=se({stripFinalNewline:!0},I),p=se({stripFinalNewline:!0},b);return Ce({stdout:f,stderr:p,error:u,exitCode:h,signal:k,timedOut:_,command:"osascript",options:e,parentError:new Error})}var Y=w(require("os")),de=require("path");var R=(0,de.resolve)(Y.default.homedir(),"Library/Group Containers/group.com.apple.notes/NoteStore.sqlite");function L(r){return r.replace(/"/g,'\\"')}function he(r){return r.replace(/'/g,"''")}function q(r){return`${parseInt(Y.default.release().split(".")[0],10)>=23?"applenotes":"notes"}://showNote?identifier=${r}`}async function pe(r){let n=r?L(r):"";return Z(`
    tell application "Notes"
      activate
      set newNote to make new note
      if ("${n}" is not "") then
        set body of newNote to "${n}"
      end if
      set selection to newNote
      show newNote
    end tell
    `)}async function me(r,n){return Z(`
    tell application "Notes"
      set theNote to note id "${L(r)}"
      set body of theNote to (body of theNote) & "${L(n)}"
    end tell
    `,{timeout:3e4})}function N(r){return r.normalize("NFD").replace(/[\u0300-\u036f]/g,"").toLowerCase()}var ze=[["\xE0\xE1\xE2\xE3\xE4\xE5","a"],["\xE8\xE9\xEA\xEB","e"],["\xEC\xED\xEE\xEF","i"],["\xF2\xF3\xF4\xF5\xF6","o"],["\xF9\xFA\xFB\xFC","u"],["\xFD\xFF","y"],["\xF1","n"],["\xE7","c"]];function Q(r){return`LOWER(${ze.reduce((e,[t,a])=>[...t,...t.toUpperCase()].reduce((i,s)=>`REPLACE(${i}, '${s}', '${a}')`,e),r)})`}async function ge(r,n=[],e,t=!1){let a=e?.trim(),i=a?he(N(a)):"",s=a?[...a].some(f=>f.charCodeAt(0)>127):!1,o="";a&&t&&!s?o=` AND ${Q("TRIM(note.ztitle1)")} = '${i}'`:a&&!t&&(o=` AND (
      ${Q("note.ztitle1")} LIKE '%${i}%' OR
      ${Q("note.zsnippet")} LIKE '%${i}%'
    )`);let c=`
    SELECT
        'x-coredata://' || zmd.z_uuid || '/ICNote/p' || note.z_pk AS id,
        note.z_pk AS pk,
        note.ztitle1 AS title,
        folder.ztitle2 AS folder,
        datetime(note.zmodificationdate1 + 978307200, 'unixepoch') AS modifiedAt,
        note.zsnippet AS snippet,
        acc.zname AS account,
        note.zidentifier AS UUID,
        (note.zispasswordprotected = 1) as locked,
        (note.zispinned = 1) as pinned,
        (note.zhaschecklist = 1) as checklist,
        (note.zhaschecklistinprogress = 1) as checklistInProgress
    FROM 
        ziccloudsyncingobject AS note
    INNER JOIN ziccloudsyncingobject AS folder 
        ON note.zfolder = folder.z_pk
    LEFT JOIN ziccloudsyncingobject AS acc 
        ON note.zaccount4 = acc.z_pk
    LEFT JOIN z_metadata AS zmd ON 1=1
    WHERE
        note.ztitle1 IS NOT NULL AND
        note.zmodificationdate1 IS NOT NULL AND
        note.z_pk IS NOT NULL AND
        note.zmarkedfordeletion != 1 AND
        folder.zmarkedfordeletion != 1
        ${o}
    ORDER BY
        note.zmodificationdate1 DESC
    LIMIT ${r}
  `,l=await A(R,c);if(!l||l.length===0)return[];let u=[];try{u=await A(R,`
      SELECT
          inv.zshareurl AS invitationLink,
          'x-coredata://' || zmd.z_uuid || '/ICNote/p' || note.z_pk AS noteId
      FROM
          ziccloudsyncingobject AS note
      LEFT JOIN zicinvitation AS inv 
          ON note.zinvitation = inv.z_pk
      LEFT JOIN z_metadata AS zmd ON 1=1
      WHERE
          note.zmarkedfordeletion != 1
    `)}catch{}let h=await A(R,`
    SELECT
      note.z_pk AS notePk,
      link.zidentifier AS id,
      link.ZALTTEXT as text,
      link.ZTOKENCONTENTIDENTIFIER as url
    FROM
      ziccloudsyncingobject AS note
    JOIN ziccloudsyncingobject AS link ON note.z_pk = link.ZNOTE1
    WHERE
      link.ZTYPEUTI1 = 'com.apple.notes.inlinetextattachment.link'
  `),k=await A(R,`
    SELECT
      note.z_pk AS notePk,
      link.zidentifier AS id,
      link.ZALTTEXT as text
    FROM
      ziccloudsyncingobject AS note
    JOIN ziccloudsyncingobject AS link ON note.z_pk = link.ZNOTE1
    WHERE
      link.ZTYPEUTI1 = 'com.apple.notes.inlinetextattachment.hashtag'
  `),_={},I=l.filter(f=>{let p=_[f.id];return p||(_[f.id]=!0),!p}).sort((f,p)=>f.modifiedAt&&p.modifiedAt&&f.modifiedAt<p.modifiedAt?1:-1),b=I.map(f=>{let p=u?.find($=>$.noteId===f.id),T=h?.filter($=>$.notePk===f.pk),X=[];h?.forEach($=>{if($.url?.includes(f.UUID.toLowerCase())){let D=I.find($e=>$e.pk===$.notePk);if(!D)return;X.push({id:$.id,title:D.title,url:q(D.UUID)})}});let be=k?.filter($=>$.notePk===f.pk);return{...f,url:q(f.UUID),invitationLink:p?.invitationLink??null,links:T??[],backlinks:X??[],tags:be??[]}});if(n.length&&(b=b.filter(f=>{let p=f.tags.map(T=>T.text);return n.every(T=>p.includes(`#${T.replace("#","")}`))})),a){let f=N(a);b=b.filter(p=>t?N(p.title.trim())===f:N(p.title).includes(f)||N(p.snippet).includes(f)),t&&(b=b.slice(0,r))}return b}var Le=async r=>{await(0,g.closeMainWindow)();let n=r.fallbackText||r.arguments.text,e=r.arguments.instructions,t=r.arguments.note?.trim(),a;if(t){await(0,g.showToast)({style:g.Toast.Style.Animated,title:"Looking for note"});let i=await ge(10,[],t,!0);if(i.length===1&&(a=i[0]),i.length>1){await z(new Error(`Multiple notes titled "${t}" were found. Please use a more specific title.`),{title:"Note title is ambiguous"});return}if(!a){await z(new Error(`No note matching "${t}" was found.`),{title:"Could not find note"});return}}await(0,g.showToast)({style:g.Toast.Style.Animated,title:a?"Adding to note":"Creating a note"});try{let i=await g.AI.ask(`Write a note based on this text: ${n}. 
      
Follow these instructions:
- The result should be formatted as HTML wrapped in a <div> tag. Don't enclose the results in backticks.
- The note should be clear and concise.
- The title should be short and descriptive and wrapped in an <h1> tag.
- Don't directly address the reader. Write the note from an objective point of view.
- Use the same language as the original text.
${e?`- ${e}`:""}
`);a?await me(a.id,i):await pe(i)}catch(i){await z(i,{title:a?"Could not add to the note.":"Could not create a new note."})}};
