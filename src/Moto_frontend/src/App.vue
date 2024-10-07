<script setup>
import { ref, computed } from 'vue';
import { Moto_backend } from 'declarations/Moto_backend/index';

// Zmienne
let first_text = "The Message ID :";
let second_text = "Use Id and Password to Read Message";
let id_field = ref("Unknown");
let zmienna = ref('');
const textRef = ref(null);
const content = ref('');
const password = ref('');
const idx = ref();
const passx = ref('');
const output = ref('>_Message Text ...');
const confirmPassword = ref('');
let isLoading = ref(false);
const passwordsMatch = computed(() => password.value === confirmPassword.value);

async function checkMessage()
{
  try {
      isLoading.value = true;
      const res = await Moto_backend.pobierzRekord(idx.value,passx.value);
      output.value = res;
      isLoading.value = false;
     }
  catch (error) 
  {
   alert('Message with that Password and Id not Found');
  }

}

async function saveContent() {
  try {
    isLoading.value = true;
    const result = await Moto_backend.zapiszTekst(content.value, password.value); 
    id_field.value = result;
    content.value='';
    isLoading.value = false;
      } catch (error) {
      console.error('Error retrieving data from the canister', error);
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

let currentTab = ref('tab1');
</script>
<template>
<title>Ghost Messages</title>
 <div class="header">
    <div class="logo">
     <img src="./logo.png" alt="Logo" />
    </div>
    <div class="buttons">
      <button @click="currentTab = 'tab1'" class="header-btn">Write Message</button>
      <button @click="currentTab = 'tab2'" class="header-btn2">Read Message</button>
       <button @click="currentTab = 'tab3'" class="header-btn3">Info</button>
    </div>
  </div>
<div style="padding:20px;">
</div>
<div v-if="currentTab === 'tab1'">
<div class="editor-container">

    <textarea
      v-model="content"
      ref="textRef"
      class="editor"
      placeholder="Enter the text to hide here..."
      rows="10"
    ></textarea>

    <input
      v-model="password"
      type="password"
      class="password-input"
      placeholder="Enter password"
    />

    <input
      v-model="confirmPassword"
      type="password"
      class="password-input"
      placeholder="Confirm password"
    />

     <div class="copy-container">
    <button
      @click="saveContent"
      class="save-button"
      :disabled="!passwordsMatch"
    >Save</button>
   
     <button class="save-button-clip" @click="copyToClipboard('' + id_field)">
       Copy
      </button>
     
    </div><div id="Id_Place">
  <h5>
    <span v-if="isLoading" class="loader">
      <i class="pi pi-spin pi-cog" style="font-size: 2rem;"></i> 
    </span>
    <span v-else class="done">
      <i class="pi pi-check" style="font-size: 2rem;"></i> 
    </span>
    {{ first_text }}
    <span style="background-color:black; color:yellow;">
      {{ id_field }}
    </span>
  </h5>
</div>
   
    <p v-if="!passwordsMatch" class="error-message">Passwords do not match!</p>
  </div>
  </div>
  <div v-if="currentTab === 'tab2'">


 <div class="editor-container" style="margin-top:75px;">
    <label for="idx" style="margin-top:35px;">ID:</label>
    <input class="input" v-model="idx" id="idx" type="number" >

    <label for="passx">Password:</label>
    <input class="input" v-model="passx" id="passx" type="password">

    <button class="save-button" @click="checkMessage">Show Message</button>
     <button class="save-button-clip" @click="copyToClipboard('' + output)">
       Copy
      </button>
         <div v-if="isLoading" class="loader" style="margin-left: 10px;"> 
      <i class="pi pi-spin pi-cog" style="font-size: 2rem;"></i>
    </div>
    <div v-else class="done" style="margin-left: 10px;"> 
    <i class="pi pi-check" style="font-size: 2rem;"></i>
    </div>


    
<textarea
  v-model="content"
  ref="textRef"
  class="editor"
  :placeholder="output"
  rows="10"
   readonly
   style="margin-top:10px;"
></textarea>
  </div>
  </div>
  <div v-if="currentTab === 'tab3'">

 <div class="editor-container" style="margin-top:45px;">
<h5>Instruction for Messages Disappearing After Reading</h5>
    <ul>
      <li>
        <h3>What is this application for ?</h3>
        <p>The Ghost Messages application was created to generate self-destructing messages. 
          You set a password and enter the message content, after which you receive an ID. 
          You can give this ID and password to someone. 
          After the message is read, it will be deleted, meaning the reader can only view it once</p>
      </li>
      <li>
        <h3>How long will my message be stored ?</h3>
        <p>Until someone reads it using the ID and password. 
          After the message is read, its content is permanently deleted</p>
      </li>
      <li>
        <h3>What can I use this for? </h3>
        <p>For anything you need to share without leaving a trace. Do you need to send someone a bank account number and don’t 
          want to leave a trace in an email or on Facebook? Do you need to send someone a software key or confidential information?
           Ghost Messages is made for that. The application runs on the ICP blockchain, which makes it independent 
           from centralized entities</p>
      </li>
      <li>
        <h3>How to save and read a disappearing message?</h3>
        <p><ul> <li><p>1) Select "Write Message"</p></li>
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
        <p>To read the message, if you already have the ID and password, go to 'Read Message', 
          the green button on the top black bar, and enter the message ID and password in the respective fields,
           then press the blue 'Show Message' button. 
           The message you read will be deleted immediately after you display it, so you will only 
           be able to see it once. The ID is numerical; note that there are no spaces at the beginning or 
           end of the ID. The password can be anything. You can copy the message using the green 'Copy' button</p>
      </li>


    </ul>

</div>
</div>

<div class="footer" style="text-align: center; padding: 10px;">
  <span style="margin-right: 10px;">©</span> 
  2024 Simple Blockchain Company -[]-[]-[]-
  <div style="display: flex; justify-content: center; align-items: center; margin-top: 1px;">
    <center>
    <img 
      src="./iclogo.svg" 
      alt="Powered by ICP Blockchain" 
      style="width: 40px; height: auto; margin-right: 2px;" 
    />
    </center>
  </div>
</div>



</template>

<style scoped>

.header {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  background-color: black;
  padding: 10px 20px;
  color: white;
  position: fixed; 
  width: 100%; 
  z-index: 1000; 
}

.header-btn {
  background-color: #007bff; 
  border: none;
  color: white;
  padding: 10px 20px;
  cursor: pointer;
  font-size: 16px;
  border-radius: 5px;
  margin-left: 10px; 
}

.header-btn:hover {
  background-color: #0056b3; 
}


.header-btn.special {
  background-color: #28a745; 
}

.header-btn.special:hover {
  background-color: #0f6423; 
}

.header-btn2 {
  background-color: #60b55b; 
  border: none;
  color: white;
  padding: 10px 20px;
  cursor: pointer;
  font-size: 16px;
  border-radius: 5px;
  margin-left: 10px; 
}

.header-btn2:hover {
  background-color: #075437; 
}


.header-btn2.special {
  background-color: #0b3b16; 
}

.header-btn2.special:hover {
  background-color: #23b545; 
}


.header-btn3 {
  background-color: #623aba; 
  border: none;
  color: white;
  padding: 10px 20px;
  cursor: pointer;
  font-size: 16px;
  border-radius: 5px;
  margin-left: 10px; 
}

.header-btn3:hover {
  background-color: #4e1458; 
}


.header-btn3.special {
  background-color: #2d0530; 
}

.header-btn3.special:hover {
  background-color: #230831; 
}

ul {
  padding: 0;
}

li {
  list-style-type: none;
  margin: 20px 0;
  background-color: #f0f0f0;
  padding: 15px;
  border-left: 5px solid #4caf50;
  border-radius: 5px;
}

li h2 {
  margin: 0 0 10px;
  font-size: 18px;
}

li p {
  margin: 0;
  font-size: 16px;
}

@media (max-width: 600px) {
  li h2 {
    font-size: 16px;
  }

  li p {
    font-size: 14px;
  }
}


.logo img {
  width: 170px;
  height: 49px;
  object-fit: cover;
}

.editor-container {
  position: relative; 
  top: 10px; 
  margin-top: 90px; 
  left: 0;
  right: 0;
  width: 100%;
  padding: 20px;
  box-sizing: border-box;
  margin: 0 auto;
  max-width: 1200px; 
}

.editor {
  margin-top:75px;
  width: 100%;
  padding: 15px;
  border-radius: 5px;
  border: 1px solid #ccc;
  font-size: 16px;
  resize: vertical;
  box-sizing: border-box;
  margin-bottom: 20px;
}

.input {
  width: 100%;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
  font-size: 16px;
  margin-bottom: 20px;
  box-sizing: border-box;
}

.password-input {
  width: 100%;
  padding: 10px;
  border-radius: 5px;
  border: 1px solid #ccc;
  font-size: 16px;
  margin-bottom: 20px;
  box-sizing: border-box;
}
.save-button {
  background-color: #007bff;
  color: white;
  border: none;
  padding: 10px 20px;
  font-size: 16px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.save-button-clip {
  background-color: #36a07d;
  margin-left:5px;
  color: white;
  border: none;
  padding: 5px 10px;
  font-size: 18px;
  border-radius: 2px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.save-button-clip:hover {
  
  background-color: #095327;
  color: white;
   margin-left:5px;
  border: none;
  padding: 5px 10px;
  font-size: 18px;
  border-radius: 5px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}



.save-button:disabled {
  background-color: #ccc;
  cursor: not-allowed;
}

.save-button:hover:enabled {
  background-color: #0056b3;
}

.error-message {
  color: red;
  font-size: 14px;
  margin-top: -20px;
  font-weight: bold; 
}


@media (max-width: 768px) {
  .editor-container {
    padding: 10px;
  }

  .editor {
    font-size: 14px;
  }

  .password-input {
    font-size: 14px;
  }

  .save-button {
    font-size: 14px;
    padding: 8px 16px;
  }
}

.footer {
  font-size: 14px;
  background-color: black;
  color: white;
  text-align: center;
  padding: 10px;
  position: fixed;
  width: 100%;
  bottom: 0;
}

.copy-container {
  float : left; 
  position: relative; 
  display: inline-flex; 
  align-items: center; 
}


.loader {
  /* Style dla kręcącego się koła zębatego */
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px; /* Odstęp górny */
}

.done {
  /* Style dla symbolu V */
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px; /* Odstęp górny */
}


</style>