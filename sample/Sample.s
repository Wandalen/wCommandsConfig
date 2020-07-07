
let _ = require( 'wTools' );
require( 'wcommandsconfig' );

/**/

function SampleClass()
{
  return _.workpiece.construct( Self, this, arguments );
}

function executable1( e )
{
  console.log( 'executable1' );
}

function exec()
{

  let Commands =
  {
    'action first' : { e : executable1, h : 'Some action' },
  }

  let ca = _.CommandsAggregator
  ({
    basePath : __dirname,
    commands : Commands,
    commandPrefix : 'node ',
  });

  this._commandsConfigAdd( ca );

  ca.form();
  ca.exec();

}

let Extend =
{
  exec : exec,
}

_.classDeclare
({
  cls : SampleClass,
  extend : Extend,
});

_.Copyable.mixin( SampleClass );
_.CommandsConfig.mixin( SampleClass );

let sample = new SampleClass();
sample.exec();
