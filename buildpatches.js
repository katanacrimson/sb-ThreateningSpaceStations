/*jslint node: true, asi: true */
"use strict"
let path = require('path')
let sbPatchbuilder = require('sb-buildpatches')
let config = require('./config.json')
config = config || {}
sbPatchbuilder({
	workingDir: config.workingDir || path.join(__dirname, 'modified'),
	dest: config.dest || path.join(__dirname, 'src'),
	starboundAssets: config.starboundAssets || process.env.STARBOUND_PATH
})