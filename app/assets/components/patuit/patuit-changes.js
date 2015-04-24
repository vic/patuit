Polymer('patuit-changes', {
  ready: function () {
    this.db = new PouchDB(this.name, this.options);
  },
  changes: function (options) {
    if(this.changes.subscription) {
      this.changes.subscription.cancel();
    }
    var that = this;
    this.changes.subscription = this.db.changes(options).on('change', function(change) {
      that.fire('change', change.doc.tweets);
      this.db.remove(change.doc);
    })
  }
})