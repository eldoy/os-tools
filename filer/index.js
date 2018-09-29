const path = require('path')
const log = require('rainlog')
const Dugg = require('dugg')
const loader = require('conficurse')
const yargs = require('yargs')

// Collect file names
const files = yargs.argv._
console.log(files)

// Load config
const config = loader.load('config.yml')
Dugg.config(config)

// Upload files
const run = async (file) => {
  const upload = new Dugg(file)
  try {
    const res = await upload.s3({ bucket: '7ino' })
    log.green(`${log.pp(res)}`)
    console.log(res['Location'])
  } catch (err) {
    log.red(`Upload error: ${err.message}`)
  }
}

for (const file of files) {
  const name = path.basename(file)
  run({ name, path: file })
}
