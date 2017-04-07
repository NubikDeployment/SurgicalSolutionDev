* {
  box-sizing: border-box;
}

html,body {
  height: 100%;
  padding: 0;
  margin: 0;
  background: #f6f8fa;
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  font-size: 12px;
}

.button {
  background: #d1d8e0;
  border-radius: 2px;
  height: 32px;
  line-height: 32px;
  padding-left: 32px;
  padding-right: 32px;
  text-decoration: none;
  color: #484848;
  outline: none;
}
.button:hover,
.button.active {
  background: #2891d4;
  color: #fff;
}
.button:active {
  box-shadow: inset 1px 1px 1px 0px rgba(50, 50, 50, 0.3);
}
.button.tab {
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
}

.heading {
  position: absolute;
  width: 100%;
  height: 52px;
  line-height: 52px;
  z-index: 100;
  background: #fff;
  border-bottom: 1px solid #e6eaed;
  box-shadow: 0 2px 2px -2px #e6eaed;
  overflow: hidden;
}

.heading .tabs {
  float: left;
  margin: 0;
  padding: 0;
  padding-left: 10px;
  padding-top: 10px;
  list-style: none;
}

.heading .tabs li {
  float: left;
  margin-right: 10px;
  font-weight: bold;
}

.heading .tabs li a {
  float: left;
}

.content {
  float: left;
  width: 100%;
  height: 100%;
}

.content iframe {
  display: none;
  width: 100%;
  height: 100%;
  border: 0;
}

.content iframe.active {
  display: block;
}
