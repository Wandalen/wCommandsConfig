( function _CommandsConfig_s_() {

'use strict';

/**
  @module Tools/mid/CommandsConfig - Collection of CLI commands to manage config. Use the module to mixin commands add/remove/delete/set to a class.
*/

/**
 * @file commands/CommandsConfig.s.
 */

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../../dwtools/Base.s';
    let toolsExternal = 0;
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

  let _ = _global_.wTools;

  _.include( 'wProto' );
  _.include( 'wCommandsAggregator' );

}

//

let _global = _global_;
let _ = _global_.wTools;
let Parent = null;
let Self = function wCommandsConfig( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'CommandsConfig';

// --
//
// --

function _commandsConfigAdd( ca )
{
  let self = this;

  _.assert( ca instanceof _.CommandsAggregator );
  _.assert( arguments.length === 1 );

  let commands =
  {
    'config will' :            { e : self.commandConfigWill.bind( self ), h : 'Print config which is going to be saved' },
    'config read' :            { e : self.commandConfigRead.bind( self ), h : 'Print content of config files' },
    'config define' :          { e : self.commandConfigDefine.bind( self ), h : 'Define config fields' },
    'config append' :          { e : self.commandConfigAppend.bind( self ), h : 'Define config fields appending them' },
    'config clear' :           { e : self.commandConfigClear.bind( self ), h : 'Clear config fields' },
    'config default' :         { e : self.commandConfigDefault.bind( self ), h : 'Set config to default' },
  }

  ca.commandsAdd( commands );

  return ca;
}

//

function _commandConfigWill( e )
{
  let self = this;
  let fileProvider = self.fileProvider;
  let logger = self.logger || _global_.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 0 );
  _.assert( self.opened !== undefined, 'Expects field {-opened-}' );

  // if( !self.formed )
  // self.form();

  // if( !self.opened )
  // {
  //   let storageFilePath = self.storageFilePathToLoadGet();
  //   if( storageFilePath === null )
  //   {
  //     logger.log( 'No storage to load at', path.current() );
  //     return;
  //   }
  //   self.sessionOpen();
  // }

  let storage = self.storageToSave({});
  logger.log( _.toStr( storage, { wrap : 0, multiline : 1, levels : 2 } ) );

  return self;
}

//

function commandConfigWill( e )
{
  let self = this;
  let fileProvider = self.fileProvider;
  let logger = self.logger || _global_.logger;

  _.assert( arguments.length === 1 );

  self._commandConfigWill();

  return self;
}
//

function commandConfigRead( e )
{
  let self = this;
  let fileProvider = self.fileProvider;
  let path = fileProvider.path;
  let logger = self.logger || _global_.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );
  _.assert( self.opened !== undefined );

  let storageFilePath = self.storageFilePathToLoadGet();
  if( storageFilePath === null )
  {
    logger.log( 'No storage to load at', path.current() );
    return;
  }

  let read = self._storageFilesRead({ storageFilePath : storageFilePath });

  logger.log( 'Storage' );
  logger.up();
  for( let r in read )
  {
    logger.log( r );
    logger.up();
    logger.log( _.toStr( read[ r ].storage, { wrap : 0, multiline : 1, levels : 2 } ) );
    logger.down();
  }
  logger.down();

  // if( !self.opened )
  // self.sessionOpen();

  return self;
}

//

function commandConfigDefine( e )
{
  let self = this;
  let fileProvider = self.fileProvider;
  let logger = self.logger || _global_.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.sessionPrepare();

  debugger;
  let storage = self.storageToSave({});
  storage = _.mapExtend( storage, e.propertiesMap );
  self.storageLoaded({ storage : storage });

  self.sessionSave();

  self._commandConfigWill();

  return self;
}

//

function commandConfigAppend( e )
{
  let self = this;
  let fileProvider = self.fileProvider;
  let logger = self.logger || _global_.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.sessionPrepare();

  debugger;
  let storage = self.storageToSave({});
  storage = _.mapExtendAppendingAnythingRecursive( storage, e.propertiesMap );
  self.storageLoaded({ storage : storage });

  self.sessionSave();

  self._commandConfigWill();

  return self;
}

//

function commandConfigClear( e )
{
  let self = this;
  let fileProvider = self.fileProvider;
  let logger = self.logger || _global_.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  if( _.mapKeys( e.propertiesMap ).length )
  {

    self.sessionPrepare();
    let storage = self.storageToSave({});
    _.mapDelete( storage, e.propertiesMap );
    self.storageLoaded({ storage : storage });
    self.sessionSave();
    self._commandConfigWill();

  }
  else
  {

    fileProvider.fileDelete
    ({
      filePath : self.storagePathGet().storageFilePath,
      verbosity : 3,
      throwing : 0,
    });

  }

  return self;
}

//

function commandConfigDefault( e )
{
  let self = this;
  let fileProvider = self.fileProvider;
  let logger = self.logger || _global_.logger;

  _.assert( _.instanceIs( self ) );
  _.assert( arguments.length === 1 );

  self.sessionPrepare();

  let storage = self.storageDefaultGet();
  self.storageLoaded( storage );
  self.sessionSave();

  _.assert( !!self.opened );

  self._commandConfigWill();

  return self;
}

// --
//
// --

let Composes =
{
}

let Aggregates =
{
}

let Associates =
{
}

let Restricts =
{
}

let Statics =
{
}

let Forbids =
{
}

let Accessors =
{
}

// --
// declare
// --

let Supplement =
{

  _commandsConfigAdd : _commandsConfigAdd,
  _commandConfigWill : _commandConfigWill,

  commandConfigWill : commandConfigWill,
  commandConfigRead : commandConfigRead,
  commandConfigDefine : commandConfigDefine,
  commandConfigAppend : commandConfigAppend,
  commandConfigClear : commandConfigClear,
  commandConfigDefault : commandConfigDefault,

  //

  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,
  Statics : Statics,
  Forbids : Forbids,
  Accessors : Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  supplement : Supplement,
  withMixin : true,
  withClass : true,
});

// --
// export
// --

_global_[ Self.name ] = _[ Self.shortName ] = Self;

if( typeof module !== 'undefined' )
if( _global_.WTOOLS_PRIVATE )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
