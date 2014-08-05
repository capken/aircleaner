var Product = Backbone.Model.extend({
  urlRoot: "products"
});

var Products = Backbone.Collection.extend({
  url: function() {
    return '/suggest?room_size=' + this.room_size +
      "&page=" + this.page;
  },
  page: 1,
  room_size: 15,
  parse: function(resp, xhr) {
    return resp.products;
  }
});

var SearchBarView = Backbone.View.extend({
  initialize: function(options) {
    this.products = options.products;
  },

  render: function() {
    var template = _.template($("#search_template").html(), {});
    this.$el.html(template);
    return this.el;
  },

  events: {
    "click button": "doSearch"
  },

  doSearch: function(event) {
    var room_size = $("#room_size").val();
    this.products.room_size = room_size;

    this.products.fetch({
      success: function(products) {
        router.navigate("search/query", true);
      }
    });
  }
});

var SearchResultsView = Backbone.View.extend({
  initialize: function(options) {
    this.products = options.products;
  },

  render: function() {
    var template = _.template($("#results_template").html(),
      {products: this.products.models, _:_}
    );
    this.$el.html(template);
    Holder.run();
    return this.el;
  }
});

var AppRouter = Backbone.Router.extend({

  routes: {
    "search": "showSearchBar",
    "search/:query": "showSearchResults",
    "products/:id": "showProduct"
  },

  showSearchBar: function() {
    this.updateView("#content", searchBarView);
    console.log("show search bar");
  },

  showSearchResults: function(query) {
    this.updateView("#content", searchResultsView);
    Holder.run();
    console.log("show search results");
  },

  showProduct: function(id) {
    console.log("show product details");
  },

  updateView: function(selector, view) {
    if(this.currentView) {
      this.currentView.remove();
    }

    $(selector).html(view.render());
    this.currentView = view;
  }
});

var products = new Products();
var searchBarView = new SearchBarView({ products: products });
var searchResultsView = new SearchResultsView({ products: products });
var router = new AppRouter();
Backbone.history.start();
