/*jslint node: true, asi: true */
"use strict"
let path = require('path')
let sbValidator = require('sb-validatejson')
let config = require('./config.json')
config = config || {}
sbValidator({
	modDir: config.dest || path.join(__dirname, 'src')
})