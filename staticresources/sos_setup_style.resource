.noSidebarCell {
  background: #E0E5E9;
}

h1 {
  display: block;
  margin: 16px 0 24px;
  text-align: center;
  font-size: 32px;
  font-weight: normal;
  color: #293F54;
}

h2 {
  font-size: 18px;
  color: #2E4153;
  padding: 14px 0 0;
  margin: 0;
  background-color: #FFF;
}

p {
  font-weight: 300;
  font-size: 14px;
  line-height: 20px;
  color: #647687;
  padding: 2px 0 14px 0;
  margin: 0;
}

.p-like {
  font-weight: 300;
  font-size: 14px;
  line-height: 20px;
  color: #647687;
  padding: 2px 0 14px 0;
  margin: 0;
}

.source {
  padding: 0px 9px;
  color: #666;
  display: inline-block;
}

.mybutton {
  display: inline-block;
  float: right;
  min-width: 150px;
  margin: 10px 0 10px 15px;
  padding: 9px 20px;
  line-height: 1.5;
  text-align: center;
  border: 1px solid #1c78b1;
  border-radius: 5px;
  font-size: 16px;
  color: white;
  background-color: #3F9FD9;
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#3F9FD9), to(#2789C7));
  background-image: -webkit-linear-gradient(top, #3F9FD9, #2789C7);
  background-image: -moz-linear-gradient(top, #3f9fd9, #2789c7);
  background-image: -ms-linear-gradient(top, #3f9fd9, #2789c7);
  background-image: -o-linear-gradient(top, #3f9fd9, #2789c7);
}

.mybutton:hover {
  background: #3F9FD9 !important;
  text-decoration: none;
  color: white;
}

.mybutton:active {
  background: #278AC7 !important;
}

.mybutton.littlebutton {
    min-width: inherit;
    margin: 0 0 0 0;
    padding: 10px 10px;
    font-size: inherit;
    position: relative;
    float: inherit;
    line-height: 0;
}


.accordion {
  max-width: 800px;
  margin: 12px auto 100px;
}

.accordion-group {
  background: white;
  margin-bottom: 8px;
  border-radius: 6px;
  overflow: hidden;
  border: 1px solid #D8D4D4;
}

.accordion-heading .accordion-toggle {
  font-size: 20px;
  line-height: 1.55;
  padding: 18px;
  background-color: #FFF;
  background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#FFF), to(#F1F1F1));
  background-image: -webkit-linear-gradient(top, #FFF, #F1F1F1);
  background-image: -moz-linear-gradient(top, #ffffff, #f1f1f1);
  background-image: -ms-linear-gradient(top, #ffffff, #f1f1f1);
  background-image: -o-linear-gradient(top, #ffffff, #f1f1f1);
  -webkit-transition: all 0.15s ease;
  -moz-transition: all 0.15s ease;
  -o-transition: all 0.15s ease;
  transition: all 0.15s ease;
}

.accordion-heading a.accordion-toggle:active {
  background: #FAFBFD !important;
}

.accordion-heading a.accordion-toggle:hover {
  text-decoration: none;
  color: #4AB471;
}

.accordion-heading .accordion-toggle span {
  display: inline-block;
  width: 1.5em;
  height: 1.5em;
  margin-right: .25em;
  border-radius: 50%;
  text-align: center;
  background: #4AB471;
  color: white;
}

.accordion-inner {
  padding: 2em;
}

.accordion-img {
  border: 1px solid #ddd;
  padding: 16px;
  margin-top: 24px;
  border-radius: 5px;
  box-shadow: 0 2px 8px rgba(0,0,0,.1);
}

.select-settings {
  padding: 7px 15px;
  margin-bottom: 25px;
  background: #F9FBFC;
  border-radius: 4px;
  border: 1px solid #ECEEF0;
}
.select-settings .control-wrapper {
  margin: 0;
}

.select-settings .control-wrapper label {
  width: 107px;
  padding-left: 0;
  color: #2A94D6;
}

.select-settings select {
  display: inline-block;
  margin: 0;
}

#delete_button {
  display: none;
}
#delete_button:hover {
  color: #CF5C60;
  text-decoration: none;
}

form {
  margin: 1em 0;
}

.control-wrapper {
  margin: 1em 0;
}

.control-wrapper:before,
.control-wrapper:after {
  content: "";
  display: table;
}
.control-wrapper:after {
  clear: both;
}

.control-wrapper label {
  float: left;
  width: 115px;
  text-align: right;
  color: #333;
  padding: 14px 22px 10px 10px;
  font-weight: 600;
}

.controls {
  float: left;
  width: auto;
  padding-top: 10px;
}

.controls > input,
.controls > .source {
  margin-bottom: 0;
}

.controls small {
  display: block;
  font-size: .9em;
  color: #999;
}

.controls small span {
  color: #666;
}

.form-footer {
  margin-top: 16px;
  padding-top: 1em;
  text-align: right;
  border-top: 1px solid #ddd;
 }

 .form-footer .mybutton {
   float: none;
}

.cta-link {
  float: left;
  width: 475px;
}

.cta-link p {
  font-size: 1.5em;
  line-height: 1.5;
}

.cta-link .mybutton {
  display: block;
  float: none;
  margin-left: 0;
}

.cta-qr {
    margin: auto;
  width: 210px;
  margin-bottom: 24px;
  padding: 1.2em 1em;
  background: #2A94D6;
  border-radius: 4px;
  text-align: center;
  box-shadow: 0 2px 5px rgba(0,0,0,.15);
}

.cta-qr p {
  margin: 0 0 8px;
  padding: 0;
  line-height: 1.2;
  color: white;
}

.cta-qr i {
  color:order-radius: 3px;
}

.hide_me {
  display: none;
}

.fail {
  color: red;
  font-weight: bold;
}

.pass {
  color: limegreen;
  font-weight: bold;
}

.hideit {
    display: none;
}

.limegreen {
    color: limegreen;
}

.mt {
    margin-top: -10px !important;
}

.bold {
    font-weight: bold;
}

.italic {
    font-style: italic;
}

.bottom-space {
    margin-bottom: 6px;
}

.top-space {
    margin-top: 16px;
}

.demo-input {
    margin-top: -6px;
}

.goleft {
    float: left;
}

.left {
    float: left;
}

.small-width {
    width:250px;
}

.notify-info {
    color: red;
    display: none;

}

.nofloat {
    float: none;
    margin-left: 0;
}

.instruct1 {
    position: absolute;
}

.instruct2 {
    position: absolute;
    margin-top: -10px;
}

button.org-info {
    margin-top: 5px !important;
}

.auto-labels {
    width:150px;
    float:left;
}

button.min105 {
    min-width: 105px !important;
}

.tinytext {
    font-size: 80%;
}

.fake-link {
    cursor: pointer;
    text-decoration: underline;
    color: blue;
}

#download-table {
    width: 742px;
    text-align: center;
}

.center {
    text-align: center;
}

.center-qr-cell {
    margin-left:18%
}

