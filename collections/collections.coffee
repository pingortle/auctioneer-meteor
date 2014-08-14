AppSchema = {}

makeName = (type) ->
  type: String
  label: "#{type} Name"
  max: 128

AppSchema.Organization = new SimpleSchema
  name: makeName("Organization")

Organizations = new Meteor.Collection('organizations')
Organizations.attachSchema(AppSchema.Organization)

AppSchema.Auction = new SimpleSchema
  name: makeName("Auction")
  allowedTypes:
    type: [String]
    minCount: 1
  time:
    type: Date
    label: "Date/Time"
  orgId:
    type: String
    regEx: SimpleSchema.RegEx.Id
  "items.$.id":
    type: String
    regEx: SimpleSchema.RegEx.Id
    unique: true
  "items.$.name": makeName("Item")
  "items.$.description":
    type: String
    label: "Description"
    max: 512
  "items.$.notes":
    type: [String]
    optional: true
  "items.$.type"
    type: String
    label: "Bid Type"
    autoValue: (obj) ->
      allowedTypesField = field("allowedTypes")
      allowedTypesField.value[0] if allowedTypesField.isSet and not this.isSet

Auctions = new Meteor.Collection('auctions')
Auctions.attachSchema(AppSchema.Auction)

AppSchema.Bid = new SimpleSchema
  time:
    type: Date
    label: "Date/Time"
    denyUpdate: true
    custom: ->
      largeBid = Bids.findOne "itemId": @.field("itemId").value,
        (sort:
          time: -1)
      "minDate" if largeBid.time > @.value
  itemId:
    type: String
    regEx: SimpleSchema.RegEx.Id
    denyUpdate: true
  bidderId:
    type: String
    regEx: SimpleSchema.RegEx.Id
    denyUpdate: true

Bids = new Meteor.Collection('bids')
Bids.attachSchema(AppSchema.Bid)
