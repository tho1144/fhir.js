jasmine.DEFAULT_TIMEOUT_INTERVAL = 10000

fhir = require('../coffee/adapters/ngFhirImpl.coffee')

Chance = require('chance')
chance = new Chance()

angular.module('test', ['ng-fhir'])
  .config ($fhirProvider)->
     $fhirProvider.baseUrl = 'http://try-fhirplace.hospital-systems.com'


pt = ()->
  resourceType: "Patient"
  text:{ status: "generated", div: "<div>Generated</div>"}
  identifier: [
    use: "usual"
    label: "MRN"
    system: "urn:oid:1.2.36.146.595.217.0.1"
    value: chance.ssn()
    period: { start: "2001-05-06"}
    assigner: { display: "Acme Healthcare"}
  ]
  name: [
    {use: "official", family: [chance.last()], given: [chance.first(), chance.first()]}
  ]

describe "ngFhir", ->
  $injector = angular.injector(['test'])


  it "search", (done) ->
    $injector.invoke ['$fhir', ($fhir)->
       $fhir.search('Patient', {name: 'maud'})
         .then (d)->
           # console.log('Search by patients', d)
           done()
     ]

  it "create", (done) ->
    $injector.invoke ['$fhir', ($fhir)->
       entry =
         tags: [{term: 'fhir.js', schema: 'fhir.js', label: 'fhir.js'}],
         content: pt()
       success = (res)->
         console.log('Patient created', JSON.stringify(res))
         done()
       error = (res)->
         console.log('Error Patient created', JSON.stringify(res))
         done()

       $fhir.create entry, success, error
     ]

  # bundle = '{"resourceType":"Bundle","entry":[]}'

  # it "transaction", (done) ->
  #   $injector.invoke ['$fhir', ($fhir)->
  #      $fhir.transaction(bundle)
  #        .then (d)->
  #          # console.log('Transaction', d)
  #          done()
  #    ]

  # it "history", (done) ->
  #   $injector.invoke ['$fhir', ($fhir)->
  #      $fhir.history()
  #        .then (d)->
  #          console.log('History', d)
  #          done()
  #        .error (err)->
  #          console.log('History', err)
  #    ]
