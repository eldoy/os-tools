const log = require('rainlog')
const Dugg = require('dugg')
const yargs = require('yargs')
const loader = require('conficurse')
const config = loader.load('config')
const files = yargs.argv._

console.log(files)
