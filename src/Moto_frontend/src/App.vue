<script setup>
import CryptoJS from 'crypto-js';
import { ref, computed } from 'vue';
import { Moto_backend } from 'declarations/Moto_backend/index';


// Zmienne nawet sporo zmiennych 

const outputbox = ref('');
const isHighlighted =  ref(false);
const  contento = ref('');        // Zmienna przechowująca tekst wprowadzony przez użytkownika
const maxLength = ref(2000); 
const messageEmpty = ref(false);
const isHumanVerified = ref(false);
let first_text = "6️⃣ The Message ID: ";
let second_text = "Use Id and Password to Read Message";
let id_field = ref("Unknown");
let zmienna = ref('');
const textRef = ref(null);
const content = ref('');
const content2 = ref('');
const password = ref('');
const idx = ref();
const passx = ref('');
const hashedPassword = ref('');
const output = ref('>_Message Text ...');
const confirmPassword = ref('');
let startTime = ref(Date.now()); 
const idqua = ref('');
const isHuman = ref(true);
let isLoading = ref(false);
let dynamicHeight = ref(350);
let encryptionKeyhidden = ref('49435077696C6C486974363030244F6E6544617942726F');
let encryptionPassword = ref('A$7gK!zPqX@9mVc#t8YTH0O45L$$Fo0ktF1Uc1U0y1d&0t');
let encryptionSalt = ref('fJ4&xZp@WqL1!oTm9$GandziaJArAnDObEK1');
const passwordsMatch = computed(() => password.value === confirmPassword.value);


// -------  Funkcja do Sprawdzania ( Pobierania wiadomości z serera )
// ------------------ ver 1.1.3 Ghost Messages @
// ------------------ Projekt szyfrowanych wiadomości na Blockchainie ICP
// ---------------- + Zapraszam na YT na Internet Computer PL
// PL24, PL25


const checkboxes = ref({
  option1: false,
  option2: false,
  option3: false,
  option4: false
});


function verifyCheckbox() {

  if (checkboxes.value.option2) {
  
    checkboxes.value.option1 = false;
    checkboxes.value.option3 = false;
    checkboxes.value.option4 = false;
    
    isHumanVerified.value = true;
  } else {
    isHumanVerified.value = false;
  }
}

async function checkMessage(pass)
{
  if ( isHuman.value && idqua.value ==='' && isHumanVerified.value) 
  {
  try 
  {
      isLoading.value = true;
      
     const res = await Moto_backend.pobierzRekord(idx.value, pass);
     const messageDecrypted = decryptMessage(pass, res);

   if (messageDecrypted) 
   {

    output.value = messageDecrypted;
   } else {
    output.value = 'Decryption failed or message not found ⚠️';
   }

      isLoading.value = false;
      password.value = '';
      passx.value = '';
      id_field.value = '';
     }
  catch (error) 
  {
   alert('Message with that Password and Id not Found');
  }
  }
  else 
  {
    alert('Data not Fetched');
  }

}


// ------------------ Funkcja zapisuje dane wiadomości 
// Tworzy Hasz z hasła -> używa hasza z hasła do zaszyfrowania wiadomości 
// To samo robi podczas odszyfrowywania z hasła tworzy klucz do odszyfrowania wiadomści 
// Pamiętając, że AES jest funkcją symetrycznego szyfrowania to zawsze zwróci z hasła  taki sam klucz

async function saveContent(pass) {


 if ( isHuman.value && idqua.value ==='' && isHumanVerified.value)  // Sprawdzamy na obecność innych odwiedzających niż ludzie 
 {
  try {
    isLoading.value = true;
    const messageEncrypted = encryptMessage(pass, content.value);
    const result = await Moto_backend.zapiszTekst(messageEncrypted, pass); 

    id_field.value = result;
    content.value='';
    isLoading.value = false;
    password.value = '';
    passx.value = '';
    confirmPassword.value = '';
    startTime.value = Date.now();                             // Wartość zmiennej dla czasu na obecność nieproszonych gości
      } catch (error) {
      console.error('Error retrieving data from the canister', error);
      }
  }
else 
{
alert('Error blocked syntax catched');
}

}

async function copyToClipboard(text) {
  try {

    await navigator.clipboard.writeText(text);
    alert('Copied to clipboard');
      } catch (err) {
        console.error('Failed to copy: ', err);
      }
}
//------------------- Funkcja haszująca hasło przed wysłaniem do Backendu utworzony hasz zapisujemy w zmiennej obiektu Motoko
                      // W kodzie porównujemy późiej dwa hasze 

async function hashPassword(pas) {
  const encoder = new TextEncoder();
  const data = encoder.encode(pas);  
  const hashBuffer = await window.crypto.subtle.digest('SHA-256', data);  
  
  
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
  
  return hashHex; 
}

// ------------------------------------------ Funkcja sprawdzająca wiadomość ( Odczyt 2gi przycisk )

async function sendToServer() {
 
 if(isHuman.value && idqua.value==='')
 {
   if (isNumber(idx.value))
{
 try {
   
    const datx = await hashPassword(password.value); 
    const result = await checkMessage(datx);  
     startTime.value = Date.now();
    
    
  } catch (error) {
    alert('Cannot Send any Data');
  }

 }
 else 
 {
alert('Id not Valid check spaces before number or type it again');

 }
}


}
// -------------------------- Szyfrowanie Wiadomości po stronie Klienta ----------------------

function encryptMessage(passwd, messx) {
    try {
        
        const key = CryptoJS.SHA256(passwd).toString(CryptoJS.enc.Hex);  
        const encrypted = CryptoJS.AES.encrypt(messx, key).toString();
        return encrypted;
    } catch (error) {
        alert('Encryption Message problem ');
        return null; 
    }
}

// -------------------------- Deszyfrowanie  Wiadomości po stronie Klienta ----------------------


function decryptMessage(passwd, mess) {
    try {

        const key = CryptoJS.SHA256(passwd).toString(CryptoJS.enc.Hex);  
        
        const decrypted = CryptoJS.AES.decrypt(mess, key).toString(CryptoJS.enc.Utf8);
        outputbox.value = 'decrypted';
        return decrypted;
    } catch (error) {
        alert('Decryption Message problem');
        return null;
    }
}


//--------------------------------------------  Funkcja do wywołania haszowania i zapisania wiadomości i hasza

async function saveToServer() 
{
  if(isHuman.value && idqua.value==='')
 {
  if (content.value != "")
  {
  const dat = await hashPassword(password.value);
  const a = await saveContent(dat);
  isHighlighted.value = true;
  }
  else 
  {
    alert('Message field cannot be empty dude');
    messageEmpty.value = true;
  }
  
 }
 else 
 {
  alert('..Reload the Page..');
 }
}

// ------------------------------------------------------- Funkcja na nie ludzką ingerencję wiadomo o co chodzi ... 8E

function handleSubmit() {
    const timeSpent = Date.now() - startTime.value;

    if (timeSpent < 400) {  
        isHuman.value = false;
        alert("Time Stamp dont be a bot do it slow"); 
        return false;
    } else {
        isHuman.value = true;
        return true;
    }
}


// ------------------------------------------------- Sprawdza czy id jest właściwym numerem 
   function isNumber(value) {
    return typeof value === 'number' && !isNaN(value);
}

let currentTab = ref('tab1');
startTime.value = Date.now();  // To dla weryfikacji nie ludzi 8E

</script>

<template>
  <div>
<title>Ghost Messages</title>
 <div class="header">

<div class="ghost"></div>
<div class="ghost"></div>
<div class="ghost"></div>
<div class="ghost"></div>


<div class="logo">
     <img src="./logo.png" alt="Logo" />
    </div>
    <div class="buttons">
      <button @click="currentTab = 'tab1'; startTime = Date.now()" class="header-btn">Write Message</button>
      <button @click="currentTab = 'tab2'; startTime = Date.now()" class="header-btn2">Read Message</button>
       <button @click="currentTab = 'tab3'; startTime = Date.now()" class="header-btn3">Info</button>
    </div>
  </div>
<div class="omnispace">
</div>
<div v-if="currentTab === 'tab1'">


  <div class="verification-container">
    <h3>1️⃣ Choose wisely</h3>
    <p>Prove me You are <span style="color:tomato">Not</span> a Bot</p>
    
    <div class="checkbox-group">
        <div class="checkbox-item">
            <input type="checkbox" id="option1" v-model="checkboxes.option1">
            <label for="option1">Iam <span style="color:orange">Alien 👽</span></label>
        </div>
        
        <div class="checkbox-item">
            <input type="checkbox" id="option2" v-model="checkboxes.option2" @change="verifyCheckbox">
            <label for="option2">Dude Iam <span style="color:lime">HUMAN</span>👌</label>
        </div>
        
        <div class="checkbox-item">
            <input type="checkbox" id="option3" v-model="checkboxes.option3">
            <label for="option3">I am <span style="color:azure">Duck</span>🦆</label>
        </div>
        
        <div class="checkbox-item">
            <input type="checkbox" id="option4" v-model="checkboxes.option4">
            <label for="option4">Iam <span style="color:deeppink">Robot</span> 🤖</label>
        </div>
    </div> 
</div> 




  



<form @submit.prevent="handleSubmit" class="editor-container">
<div class="editor-container">
  <div class="label">2️⃣ Enter below the content of your message to be encrypted and saved 📝</div>
  <textarea
      v-model="content"
      ref="textRef"
      class="editor"
      placeholder="Enter the text to hide here..."
      rows="14"
      :maxlength="maxLength"
      required
    ></textarea>
    <div class="character-count">
      <span>{{ content.length }} / {{ maxLength }}</span>
      <p v-if="content.length === maxLength" style="color:tomato;">
        🟠 Maximum character limit of 2000 reached 🪫
    </p>
    </div>

<input v-model="idqua" :maxlength="38" type="text" tabindex="-1"  style="  position: absolute; left: -9999px; top: -9999px; opacity: 0;" placeholder="Enter Password Sec" />
<div class="label">3️⃣ Enter New password for your message 🔓</div>
    <input
      v-model="password"
      :maxlength="40"
      type="password"
      class="password-input"
      placeholder="Create New Password "
      required
    />
    <div class="label">4️⃣ Type the password again 🔐</div>
    <input
      v-model="confirmPassword"
      :maxlength="40"
      type="password"
      class="password-input"
      placeholder="Confirm New Password"
      required
    />

     <div class="copy-container">
    <button
      @click="saveToServer"
      class="save-button"
       :disabled="!passwordsMatch || content === '' || password === '' || confirmPassword === '' || password !== confirmPassword || !isHumanVerified"
             
    >5️⃣ Save Message 🔏</button>
   
     <button class="save-button-clip" @click="copyToClipboard('' + id_field)">
       Copy
      </button>
     
    </div><div id="Id_Place" class="id-place">
  <h5>
    <span v-if="isLoading" class="loader">
     <p>Creating New ID wait a sec ...⌛️</p>
    </span>
    <span v-else class="done">
     
    </span>
    {{ first_text }}
    <span v-if="id_field" :class="{'highlight-text': isHighlighted}">
      {{ id_field }}
    </span>
  </h5>
</div>
   
    <p v-if="!passwordsMatch" class="error-message"><span style="color:darkkhaki">❗️ Password</span><span style="color:lightcoral"> do not match!</span></p>
    <p v-if="messageEmpty" class="error-message"><span style="color:firebrick">❗️ Message Cannot be Empty !</span></p>
    <p v-if="!isHumanVerified" class="error-message"><span style="color:darkkhaki">❗️ Check checkbox above that you are <span style="color:lime">HUMAN</span>👌</span><span style="color:lightcoral">!</span></p>
  </div>
   </form>
  </div>
  <div v-if="currentTab === 'tab2'">

 <form @submit.prevent="handleSubmit" class="editor-container">
  
  <div class="verification-container">
    <h3>1️⃣ Choose wisely</h3>
    <p>Prove You are <span style="color:tomato">Not</span> a Bot</p>
    
    <div class="checkbox-group">
        <div class="checkbox-item">
            <input type="checkbox" id="option1" v-model="checkboxes.option1">
            <label for="option1">Iam <span style="color:orange">Alien 👽</span></label>
        </div>
        
        <div class="checkbox-item">
            <input type="checkbox" id="option2" v-model="checkboxes.option2" @change="verifyCheckbox">
            <label for="option2">Dude Iam <span style="color:lime">HUMAN</span>👌</label>
        </div>
        
        <div class="checkbox-item">
            <input type="checkbox" id="option3" v-model="checkboxes.option3">
            <label for="option3">I am <span style="color:azure">Duck</span>🦆</label>
        </div>
        
        <div class="checkbox-item">
            <input type="checkbox" id="option4" v-model="checkboxes.option4">
            <label for="option4">Iam <span style="color:deeppink">Robot</span> 🤖</label>
        </div>
    </div> 
</div> 






 <div class="editor-container" style="margin-top:75px;">
    <label for="idx" style="margin-top:35px; margin-bottom:10px;">2️⃣ ID:</label>
    <input class="input" v-model="idx" :maxlength="60" id="idx" type="number"  placeholder="Enter Message ID here..." required>

    <label for="passx">3️⃣ Password:</label>

  
   <input class="input" id="passx" :maxlength="60" v-model="password" type="password" placeholder="Enter your password" required>

<input v-model="idqua" type="text"  style="  position: absolute; left: -9999px; top: -9999px; opacity: 0;" placeholder="Enter Password Sec" />
    <div class="show-place">
    <button class="save-button" @click="sendToServer" 
    :disabled="password === '' || idx === '' || !isHumanVerified"
    >4️⃣ Show Message 🔑</button>
     <button class="save-button-clip" @click="copyToClipboard('' + output)">
       Copy
      </button>
      <p v-if="!isHumanVerified" class="error-message"><span style="color:darkkhaki">❗️ Check checkbox above that you are <span style="color:lime">HUMAN</span>👌</span><span style="color:lightcoral">!</span></p>
    </div>
         <div v-if="isLoading" class="loader" style="margin-left: 10px;"> 
         <p>Searching for a Message...⏳</p>
    </div>
    <div v-else class="done" style="margin-left: 10px;"> 
     
    </div>
<div v-if="outputbox !== ''">Your decrypted message 📩 will be <span style="color:red">permanently deleted</span> 🪦 after closing tab</div>
<textarea
  id="toto"
  
  v-model="output"
  ref="textRef"
  class="editor"
  rows="14"
  style="margin-top:10px;"
></textarea>

</div>
 </form>

  </div>
  <div v-if="currentTab === 'tab3'">

 <div class="editor-container" style="margin-top:45px;">
<center><h5>Instruction for Messages Disappearing After Reading</h5></center>
    <ul>
      <li>
        <h3>What is this application for ?</h3>
        <p style="font-family: 'Roboto', sans-serif; font-size: 16px; line-height: 1.6;">
    The Ghost Messages application was created to generate self-destructing messages. 
    You set a password and enter the message content, after which you receive an ID. 
    You can give this ID and password to someone. 
    After the message is read, it will be deleted, meaning the reader can only view it once.
</p>
      </li>
      <li>
        <h3>How long will my message be stored ?</h3>
        <p style="font-family: 'Roboto', sans-serif; font-size: 16px; line-height: 1.6;">
        Until someone reads it using the ID and password. 
          After the message is read, its content is permanently deleted</p>
      </li>
      <li>
        <h3>What can I use this for? </h3>
        <p style="font-family: 'Roboto', sans-serif; font-size: 16px; line-height: 1.6;">
        For <span style="color:orangered">anything you need </span>to share without leaving a trace. Do you need to send someone a bank account number and don’t 
          want to leave a trace in an email or on Facebook? Do you need to send someone a software key or confidential information?
           Ghost Messages is made for that. The application runs on the ICP blockchain, which makes it independent 
           from centralized entities</p>
      </li>
      <li>
        <h3>How to save and read a disappearing message?</h3>
        <p style="font-family: 'Inter', sans-serif; font-size: 16px; line-height: 1.6; list-style-type: disc; padding-left: 20px;"><ul> <li><p>1) Select "Write Message"</p></li>
                <li><p>2) Enter the message content</p></li>
                <li><p>3) Enter the password</p></li>
                <li><p>4) Re-enter the password</p></li>
                <li><p>5) Click the blue "Save" button</p></li>
                <li><p>6) Wait about 2 seconds (A pop-up window will appear)</p></li>
                <li><p>7) An ID for your message will appear on a black background</p></li>
                <li><p>8) You can copy this ID by clicking the green "Copy" button</p></li>
                <li><p>9) Give someone the ID and password for the message</p></li>
                </ul></p>
      </li>
<li>
        <h3>How to read a disappearing message if I received the ID and password ?</h3>
        <p style="font-family: 'Roboto', sans-serif; font-size: 16px; line-height: 1.6;">To read the message, if you already have the ID and password, go to 'Read Message', 
          the green button on the top black bar, and enter the message ID and password in the respective fields,
           then press the  'Show Message' button. 
           The message you read will be deleted immediately after you display it, so you will only 
           be able to see it once. The ID is numerical; note that there are no spaces at the beginning or 
           end of the ID. The password can be anything. You can copy the message using the green <span style="color:darkseagreen">'Copy'</span> button</p>
      </li>


    </ul>

</div>
</div>

<div class="footer" style="text-align: center; padding: 10px; margin-top:30px;">
  <span style="margin-right: 10px;">©</span> 
  2025 Simple Blockchain Company -[]-[]-[]-
  
  <div style="justify-content: center; align-items: center; margin-top: 1px;">
    <img 
      src="./iclogo.svg" 
      alt="Powered by ICP Blockchain" 
      style="width: 40px; height: auto; margin-right: 2px;" 
    />
  </div>
</div>
</div>

</template>

<style>

@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Press+Start+2P&display=swap');

body {
  background: linear-gradient(135deg, #080808, #200f33, #540d6e);
  color: #f8f8f2;
  font-family: 'Orbitron', sans-serif;
  margin: 0;
  padding: 0;
  overflow-x: hidden;

}


.header {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  background: rgba(10, 10, 30, 0.9);
  padding: 15px 20px;
  color: #ff00ff;
  position: fixed;
  width: 100%;
  z-index: 1000;
  border-bottom: 3px solid #ff00ff;
  box-shadow: 0px 0px 15px rgba(255, 0, 255, 0.5);
}

@keyframes pulseAnimation {
  0% {
    background-color: black;
    color: yellow;
    transform: scale(1);
  }
  25% {
    background-color: yellow;
    color: black;
    transform: scale(1.1); 
  }
  50% {
    background-color: orange;
    color: white;
    transform: scale(1.2); 
  }
  75% {
    background-color: yellow;
    color: black;
    transform: scale(1.1); 
  }
  100% {
    background-color: black;
    color: yellow;
    transform: scale(1);
  }
}


.highlight-text {
  background-color: black;
  color: yellow;
  padding: 5px 10px;
  display: inline-block;
  animation: pulseAnimation 2s ease-out;
}

.logo img {
  width: 259px;
  height: 62px;
  object-fit: cover;
}


.header-btn,
.header-btn2,
.header-btn3 {
  background: linear-gradient(135deg, #ff0099, #ff6600);
  border: none;
  color: white;
  padding: 12px 20px;
  cursor: pointer;
  font-size: 16px;
  border-radius: 8px;
  margin-left: 10px;
  text-shadow: 2px 2px 5px #000;
  transition: all 0.3s ease-in-out;
}

.header-btn:hover,
.header-btn2:hover,
.header-btn3:hover {
  background: linear-gradient(135deg, #ff00ff, #ff5500);
  transform: scale(1.1);
  box-shadow: 0px 0px 20px rgba(255, 0, 255, 0.8);
}


.header-btn.special {
  background: linear-gradient(135deg, #00ff99, #00ccff);
}
.header-btn.special:hover {
  background: linear-gradient(135deg, #00ffcc, #0099ff);
}

.header-btn2.special {
  background: linear-gradient(135deg, #6600ff, #ff0099);
}
.header-btn2.special:hover {
  background: linear-gradient(135deg, #9900ff, #ff66cc);
}

.header-btn3.special {
  background: linear-gradient(135deg, #ff3300, #cc0099);
}
.header-btn3.special:hover {
  background: linear-gradient(135deg, #ff6600, #990066);
}


ul {
  padding: 0;
}

li {
  list-style-type: none;
  margin: 20px 0;
  background: rgba(255, 255, 255, 0.1);
  padding: 15px;
  border-left: 5px solid #ff00ff;
  border-radius: 8px;
  box-shadow: 0 0 10px rgba(255, 0, 255, 0.5);
  transition: transform 0.3s ease-in-out;
}

li:hover {
  transform: scale(1.05);
}

li h2 {
  font-size: 20px;
  margin-bottom: 10px;
  color: #ff6600;
}

li p {
  font-size: 16px;
}


.editor-container {
  position: relative;
  margin-top: 10px;
  width: 100%;
  padding: 20px;
  box-sizing: border-box;
  max-width: 1200px;
}


.editor,
.input,
.password-input {
  width: 100%;
  padding: 12px;
  border-radius: 8px;
  border: 1px solid #ff00ff;
  font-size: 16px;
  margin-top:10px;
  margin-bottom:8px;
  background: rgba(0, 0, 0, 0.7);
  color: #fff;
  box-shadow: inset 0px 0px 5px rgba(255, 255, 255, 0.3);
}

.copy-container
{
margin-top:15px;
}


.save-button
{
  background: linear-gradient(135deg, #2b7640, #bae4f5);
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 8px;
  font-size:24px;
  cursor: pointer;
  transition: 0.3s ease-in-out;
  box-shadow: 0px 0px 10px rgba(84, 157, 240, 0.8);

}
.save-button-clip {
  background: linear-gradient(135deg, #ffcc00, #ff00ff);
  color: white;
  border: none;
  padding: 12px 20px;
  border-radius: 8px;
  cursor: pointer;
  transition: 0.3s ease-in-out;
  box-shadow: 0px 0px 10px rgba(255, 0, 255, 0.8);
}

.save-button:hover
{
  background: linear-gradient(135deg, #0ef851, #07a5d5);
  transform: scale(1.2);

}
.save-button-clip:hover {
  background: linear-gradient(135deg, #ff9900, #ff0099);
  transform: scale(1.1);
}

.save-button:disabled {
  background: #ccc;
  font-size:23px;
  cursor: not-allowed;
}



.ghost {
  position: absolute;
  width: 30px; 
  height: 30px; 
  background-image: url('ghost.png'); 
  background-size: contain; 
  background-repeat: no-repeat; 
  z-index:-1;
  opacity:0.7;
  
  animation: floatGhost 9s infinite ease-in-out, moveGhost 14s infinite linear;
}

@keyframes floatGhost {
  0%, 100% {
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
}

@keyframes moveGhost {
  0% {
    transform: translateX(-100px); 
  }
  100% {
    transform: translateX(100vw); 
  }
}


.ghost:nth-child(odd) {
  animation-delay: -4s;
}

.ghost:nth-child(even) {
  animation-delay: -5s;
}





.loader,
.done {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
}
.verification-container {
  background: rgba(255,255,255,.1);
  border-radius: 8px;
  padding: 20px;
  margin: 20px 0;
    margin-top: 20px;
  box-shadow: 0 2px 4px #ff00ff80;
  text-align: center;
  max-width: 60%;
  margin-top: 85px;
  display: block;
    margin-left: auto;
    margin-right: auto;
}




h3 {
  color: #ff6600;
}

.checkbox-group {
  margin: 20px 0;
}

.checkbox-item {
  
  align-items: center;
  margin: 10px 0;
}

.checkbox-item input[type="checkbox"] {
  margin-right: 10px;
  width: 30px;
  height: 30px;
  cursor: pointer;
  border: 2px solid #31ffff;
  color:lime;
}

.checkbox-item label {
  font-size: 22px;
}

.footer {
  font-size: 12px;
  background: rgba(10, 10, 30, 0.9);
  color: white;
  text-align: center;
  margin-top:30px;
  padding: 10px;
  width: 100%;
  bottom: 0;
  box-shadow: 0px 0px 15px rgba(175, 48, 175, 0.5);
}

.omnispace 
  {
    padding:20px;
  }

  .show-place
  {
  margin-top:20px;
  }

  .id-place
  {
    margin-bottom:34px;
  }

#toto 
{
margin-bottom:80px;  
}
.label {
            color: #f8f8f2;
            font-family: Orbitron, sans-serif;
            background-color: #282a36;
            padding: 10px 20px;
            border-radius: 8px;
            display: inline-block;
        }

input[type="checkbox"] {
  appearance: none;
  width: 30px;
  height: 30px;
  border: 2px solid #000;
  border-radius: 5px;
  position: relative;
}

input[type="checkbox"]:checked::before {
  content: "✔";
  font-size: 28px;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.character-count {
  margin-top: 5px;
  font-size: 12px;
  color: #666;
}

/*      ------------------------------ ------------------------------- -----------------Mobne Responsywność */


@media (max-width: 768px) {


  .header {
    flex-direction: column;
    align-items: center;
  }

  .header-btn,
  .header-btn2,
  .header-btn3 {
    font-size: 14px;
    padding: 10px;
    margin-left: 0;
    margin-top: 10px;
  }

  .editor-container {
    position: relative;
    width: 94%;
    padding: 1px;
    box-sizing: border-box;
    max-width: 1200px;
  }


  .editor,
  .input,
  .password-input {
    font-size: 14px;
  }

  .save-button {
    font-size:28px;
    padding: 8px 16px;
  }
  
  .omnispace 
  {
    padding:80px;
  }

  .checkbox-item {
  display: flex;
  align-items: center;
  margin: 10px 0;
}

.verification-container {
  background: rgba(255, 255, 255, 0.1);
  border-radius: 8px;
  padding: 20px;
  
  max-width:80%;
  box-shadow: 0 2px 4px rgba(255, 0, 255, 0.5);
  text-align: center;
 

}


}


</style>
