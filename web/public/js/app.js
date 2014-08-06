var brands = ["3M","Coway","IQAir","LG","SKG","TCL","cado","三星","三菱重工","东芝","亚都","伊莱克斯","双鸟","夏普","大金","奥司汀","奥得奥","奥郎格","布鲁雅尔","席爱尔","德龙","惠而浦","松下","格力","汇清","海尔","瑞士风","美的","艾美特","范罗士","莱克","西屋","贝昂","远大","霍尼韦尔","飞利浦"];

var Product = Backbone.Model.extend({
  urlRoot: "products"
});

var Products = Backbone.Collection.extend({
  url: function() {
    var params = {
      room_size: this.room_size,
      brand: this.brand,
      page: this.page
    };

    var paramsStr = _.map(params, function(value, key){
      return key + "=" + value;
    }).join("&");

    return "/suggest?" + paramsStr;
  },
  page: 1,
  room_size: 15,
  brand: "Coway",
  parse: function(resp, xhr) {
    return resp.products;
  }
});

var BreadcrumbView = Backbone.View.extend({
  el: "#breadcrumb",

  render: function() {
    var template = _.template($("#breadcrumb_template").html(),
      { links: this.links, _:_ }
    );
    this.$el.html(template);
  },

  updateView: function(links) {
    this.links = links;
    this.render();
  }

});

var SearchBarView = Backbone.View.extend({
  initialize: function(options) {
    this.products = options.products;
  },

  render: function() {
    var template = _.template($("#search_template").html(),
      { input: this.products, brands: brands });
    this.$el.html(template);
    return this.el;
  },

  events: {
    "click button": "doSearch"
  },

  doSearch: function(event) {
    var room_size = $("#room_size").val();
    var brand = $("#brand").val();

    this.products.room_size = room_size;
    this.products.brand = brand;

    this.products.fetch({
      success: function(products) {
        router.navigate("search/results", true);
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

var productDetailsView = Backbone.View.extend({
  initialize: function(options) {
    this.model = options.product;
  },

  render: function() {
    var template = _.template($("#product_template").html(),
      {product: this.model, _:_}
    );
    this.$el.html(template);
    return this.el;
  }
});


var AppRouter = Backbone.Router.extend({

  initialize: function(options) {
    this.products = new Products();
  },

  routes: {
    "search": "showSearchBar",
    "search/results": "showSearchResults",
    "products/:id": "showProduct"
  },

  showSearchBar: function() {
    breadcrumbView.updateView([
      { href: "#search", text: "查询", active: true }
    ]);
    this.updateView("#content",
      new SearchBarView({ products: this.products }));
    console.log("show search bar");
  },

  showSearchResults: function() {
    breadcrumbView.updateView([
      { href: "#search", text: "查询" }, 
      { href: "#search/results", text: this.text(), active: true }
    ]);
    this.updateView("#content",
      new SearchResultsView({ products: this.products }));
    console.log("show search results");
  },

  showProduct: function(id) {
    var that = this;
    var product = new Product({id: id});
    product.fetch({
      success: function(product) {
        that.updateView("#content",
          new productDetailsView({product: product}));
        breadcrumbView.updateView([
          { href: "#search", text: "查询" }, 
          { href: "#search/results", text: that.text() },
          { href: "#products/" + id, text: product.get("brand") +
            " - " + product.get("model"), active: true }
        ]);
      }
    });

    console.log("show product details");
  },

  updateView: function(selector, view) {
    if(this.currentView) {
      this.currentView.remove();
    }

    $(selector).html(view.render());
    Holder.run();
    this.currentView = view;
  },

  text: function() {
    return this.products.room_size + "m²";
  }
});

var breadcrumbView = new BreadcrumbView();
var router = new AppRouter();
Backbone.history.start();
