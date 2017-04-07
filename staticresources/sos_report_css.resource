* {
  box-sizing: border-box;
}

html, body {
  height: 100%;
  margin: 0;
  padding: 0;
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  font-size: 12px;
}

body {
  padding-top: 55px;
}

body a {
  color: #2891d4;
}

.button {
  background: #d1d8e0;
  border-radius: 2px;
  border: 0;
  height: 32px;
  padding-left: 32px;
  padding-right: 32px;
  text-decoration: none;
  font-size: 1em;
  font-weight: bold;
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
.button.green {
  background: #17b031;
  color: #fff;
}
.button.green:hover {
  background: #15942a;
}

.heading {
  float: left;
  width: 100%;
  border-bottom: 1px solid #e6eaed;
  box-shadow: 0 2px 2px -2px #e6eaed;
  padding-top: 10px;
  padding-bottom: 10px;
  margin-bottom: 10px;
}

.heading h1 {
  float: left;
  width: auto;
  margin: 0;
  padding: 0;
  margin-right: 32px;
  margin-left: 10px;
}

.heading .selector {
  float: left;
}

.heading .selector .refresh-text {
  float: left;
}

.heading .selector select {
  float: left;
  height: 32px !important;
  width: 180px !important;
  border-radius: 2px;
  outline: none;
  border: 0;
  background: #ecf0f3;
  color: #383a3b;
}

.heading .selector button {
  float: right;
  margin-left: 10px;
}

.heading .selector button.left {
	float: left;
	margin-left: 0;
	margin-right: 10px;
}

.heading .selector .refresh-text {
  line-height: 32px !important;
}

.heading .selector button#refresh-stats {
  float: left;
  margin-left: 0;
  margin-right: 10px;
}

h3 {
  color: #3c3d3e;
  padding-left: 10px;
}

#charts {
  float: left;
  width: 100%;
}

#charts .chart {
  float: left;
  width: 47%;
  width: -webkit-calc(50% - 10px);
  margin: 0 0 10px 10px;
  border: 0;
  box-shadow: 1px 1px 1px 0px rgba(50, 50, 50, 0.3);
}

#data-tables {
  float: left;
  width: 100%;
  background: #fff;
}

.split-chart #data-tables {
  float: left;
  width: 47% !important;
  width: -webkit-calc(50% - 10px) !important;
}

.split-chart #data-tables .tables {
  padding-top: 0;
}

.split-chart #data-tables .tables table td {
	background: #fff !important;
}

.split-chart .chart {
  float: left;
  width: 47% !important;
  width: -webkit-calc(50% - 10px);
  margin: 0 0 10px 10px;
  border: 0;
  box-shadow: 1px 1px 1px 0px rgba(50, 50, 50, 0.3);
}

#data-tables.transparent {
  background: none;
}

#data-tables .heading {
  float: left;
  width: 100%;
  height: 52px;
  line-height: 52px;
  z-index: 100;
  border-bottom: 1px solid #e6eaed;
  box-shadow: 0 2px 2px -2px #e6eaed;
  background: #f6f8fa;
}

#data-tables .heading .tabs {
  float: left;
  margin: 0;
  padding: 0;
  padding-left: 10px;
  list-style: none;
}

#data-tables .heading .tabs li {
  float: left;
  margin-right: 10px;
  line-height: 32px;
  font-weight: bold;
}

#data-tables .heading .tabs li a {
  float: left;
}

#data-tables .tables {
  float: left;
  width: 100%;
  padding: 10px;
  padding-top: 10px;
  padding-bottom: 15px;
}

#data-tables .tables table {
  width: 100%;
  font-size: 1em;
  border-collapse: collapse;
}

#data-tables .tables table th {
  border: 1px solid #2891d4;
  border-right: 1px solid #2383c1;
  background: #2891d4;
  color: #fff;
  height: 32px;
}

#data-tables .tables table th:last-child {
  border-right: 1px solid #2891d4;
}

#data-tables .tables table td {
  border: 1px solid #d1d8e0;
  background: #f6f8fa;
  height: 32px;
  padding-left: 5px;
}

#data-tables .tables table td.label {
  background: #fff;
  width: 200px;
  padding-left: 32px;
  padding-right: 32px;
}

#data-tables .tables table td.value {
  padding-left: 32px;
  box-shadow: inset 1px 1px 0px rgba(226,232,237,0.5);
}

#data-tables .tables table tr .type {
  text-align: center;
}

#data-tables .tables table tr span.abandoned,
#data-tables .tables table tr span.completed {
  display: none;
  width: 8px;
  height: 8px;
}

#data-tables .tables table tr.abandoned-row span.abandoned {
  display: inline-block !important;
  background: #ff4f4f;
}

#data-tables .tables table tr.completed-row span.completed {
  display: inline-block;
  background: #17b031;
}

#data-tables .tables table tr.active-row span.completed {
  display: inline-block;
  background: #17b031;
}

#data-tables .tables table tr.queue-row span.queued {
  display: inline-block;
  background: #ffe266;
}

.type span {
    width: 8px;
    height: 8px;
}

.refresh-link {
    text-decoration: underline;
    color: #2891d4;
    cursor: pointer;
    font-weight: bold;
    font-size: 12px;
}

.bold {
    font-weight: bold;
}

/*
button {
    display: inline-block;
    float: right;
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
    min-width: inherit;
    margin: 0 0 0 0;
    padding: 10px 10px;
    font-size: 13px;
    position: relative;
    float: inherit;
    line-height: 0;
}

button:hover {
    background: #3F9FD9 !important;
    text-decoration: none;
    color: white;
}

button:active {
    background: #278AC7 !important;
}
*/

.agent-name {
    font-weight: bold;
}

.right {
    float: right;
}

.realtime-label {
/*    font-weight: bold; 
    color: grey;
*/
}

.is-online {
    color: #17b031;  
}

.is-offline {
    color: #ff4f4f;
}

.pie-chart {
	width: 160px;
}

.column-chart {
	width: 360px;
}

.scatter-chart {
	width: 443px;
}

.all-charts {
    margin: 2px 2px 0px 1px;
    float: left;
}

.add-border {
    border: solid;
    border-width:1px;
}

.hideit {
    display:none;
}

#agent-status {
    margin-bottom: 15px;
}

.completed-row {
    display: none;
}

.abandoned-row {
    display: none;
}

.clear {
    clear: both;
    padding-top: 25px;
}

.completed-row {
    background: rgba(42,148,214,.2);
}

.abandoned-row {
    background: rgba(233,105,110,.2);
}

.active-row {
    background: rgba(42,148,214,.2);
}

.queue-row {
    background: rgba(233,105,110,.2);
}

.active-unknown-row {
    background: rgba(167,68,220,0.2);
}

.small-height {
    height: 300px;
}

.italic {
    font-style: italic;
}
