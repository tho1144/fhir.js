var search = require('./search.coffee');
var conf = require('./conformance.coffee');
var transaction = require('./transaction.coffee');
var tags = require('./tags.coffee');
var history = require('./history.coffee');
var crud = require('./resource.coffee');

var wrapHttp = require('./http.coffee');

// cunstruct fhir object
// params:
//   * cfg - config object - props???
//   * adapter - main operations
//      * http - function({method, url, success, error})
//               call success with (data, status, headersFn, config)
function fhir(cfg, adapter){
  // TODO: add cfg & adapter validation
  var http = wrapHttp(cfg, adapter.http)
  var baseUrl = cfg.baseUrl

  return  {
    search: function(type, query, cb, err){
      return search(baseUrl, http, type, query, cb, err)
    },
    conformance: function(cb, err){
      return conf.conformance(baseUrl, http, cb, err)
    },
    profile: function(type, cb, err){
      return conf.profile(baseUrl, http, type, cb, err)
    },
    transaction: function(bundle, cb, err){
      return transaction(baseUrl, http, bundle, cb, err)
    },
    history: function(){
      return history.apply(null, [baseUrl, http].concat(arguments))
    },
    create: function(entry, cb, err){
      return crud.create(baseUrl, http, entry, cb, err)
    },
    read: function(id, cb, err){
      return crud.read.apply(baseUrl, http, id , cb, err)
    },
    update: function(entry, cb, err){
      return crud.update(baseUrl, http, entry, cb, err)
    },
    delete: function(){
      return crud.delete.apply(null, [baseUrl, http].concat(arguments))
    }
  }
}
module.exports = fhir

