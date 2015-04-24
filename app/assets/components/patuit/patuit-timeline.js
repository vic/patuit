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
  newTweet: function (e, newTweets) {
    this.timeline.unshift.apply(this.timeline, newTweets);
  },
  increaseZ: function (e, x, el) {
    el.setZ(2);
  },
  decreaseZ: function (e, x, el) {
    el.setZ(1);
  },
  refreshFriendship: function () {
    this.$.friend_info.go();
  }
})