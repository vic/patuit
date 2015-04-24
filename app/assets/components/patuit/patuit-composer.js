Polymer('patuit-composer', {
  createTweet: function () {
    this.$.ajax.go();
  },
  handleResponse: function (e, response) { 
    if (response.xhr.status === 201) {
      this.message = '';
    }
  } 
})