Polymer('patuit-timeline', {
  ready: function () {
    this.timeline = []
  },
  handleResponse: function (e, r) {
    this.timeline = r.response;
  },
  nicknameChanged: function (oldVal, newVal) {
    this.$.pouch.changes({
      live: true,
      since: "now",
      include_docs: true
    })
  },
  newTweet: function (e, change) {
    var newTweets = change.doc.tweets;
    this.timeline.unshift.apply(this.timeline, newTweets);
    this.$.pouch.db.remove(change.doc._id);
  },
  increaseZ: function (e, x, el) {
    el.setZ(2);
  },
  decreaseZ: function (e, x, el) {
    el.setZ(1);
  }
})