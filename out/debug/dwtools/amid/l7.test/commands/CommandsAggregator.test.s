( function _CommandsAggregator_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    var toolsPath = '../../../dwtools/Base.s';
    var toolsExternal = 0;
    try
    {
      toolsPath = require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

  _.include( 'wTesting' );

  require( '../../l7/commands/mixin/CommandsConfig.s' );

}


var _global = _global_;
var _ = _global_.wTools;

// --
//
// --

function trivial( test )
{

  /**/

  function SampleClass()
  {
    return _.instanceConstructor( SampleClass, this, arguments );
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

    test.is( _.routineIs( this.commandConfigDefine ) );
    test.is( Object.keys( ca.vocabulary.descriptorMap ).length > 5 );

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

}

// --
//
// --

var Self =
{

  name : 'Tools/mid/CommandsConfig',
  silencing : 1,

  tests :
  {
    trivial : trivial,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

})();
