###
# Constants used in client application.
###

module.exports =
  width: 960
  height: 640
  pack: 'assets/pack.json'

  startPage: 'Cruft'

  gravity: 600

  camera:
    slack: 50
    delay: 80

  playerCfg:
    mass: 10
    speed: 240
    jumpHeight: 420
    bounce: 0.12

  wordCfg:
    defaultStyle:
      fontSize: '32px'
      fill: '#000'
    linkColor:
      blue:      '#0645AD'
      darkBlue:  '#0B0080'
      red:       '#CC2200'
      lightRed:  '#A55858'
      brown:     '#772233'
      lightBlue: '#3366BB'
      purple:    '#663366'

  spacing:
    length: 1500
    padding: 300
    word: 60
    line: 130
    paragraph: 200
    blockSize: 1600

