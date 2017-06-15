/*jslint node: true, asi: true */
"use strict"
let path = require('path')
let sbPNGSqueeze = require('sb-pngsqueeze')
let config = require('./config.json')
config = config || {}
sbPNGSqueeze({
	modDir: config.dest || path.join(__dirname, 'src')
})