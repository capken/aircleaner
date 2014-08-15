var brands = {
  '3M' : '3M/菲尔萃',
  'Coway' : 'Coway/熊津',
  'IQAir' : 'IQAir',
  'LG' : 'LG',
  'SKG' : 'SKG',
  'TCL' : 'TCL',
  'cado' : 'cado',
  '三星' : '三星/Samsung',
  '三菱重工' : '三菱重工',
  '东芝' : '东芝/TOSHIBA',
  '亚都' : '亚都',
  '伊莱克斯' : '伊莱克斯/Electrolux',
  '双鸟' : '双鸟/TwinBird',
  '夏普' : '夏普/SHARP',
  '大金' : '大金/DAIKIN',
  '奔腾' : '奔腾/POVOS',
  '奥司汀' : '奥司汀',
  '奥得奥' : '奥得奥/Airdow',
  '奥郎格' : '奥郎格/Airgle',
  '布鲁雅尔' : '布鲁雅尔/Blueair',
  '席爱尔' : '席爱尔',
  '德龙' : '德龙/DeLonghi',
  '惠而浦' : '惠而浦/Whirlpool',
  '松下' : '松下/Panasonic',
  '格力' : '格力/GREE',
  '汇清' : '汇清',
  '海尔' : '海尔/Haier',
  '爱国者' : '爱国者',
  '爱普乐' : '爱普乐/Airpal',
  '瑞士风' : '瑞士风/AIR-O-SWISS',
  '纽贝尔' : '纽贝尔',
  '绿歌' : '绿歌',
  '美的' : '美的/Midea',
  '美菱' : '美菱',
  '艾美特' : '艾美特/Airmate',
  '范罗士' : '范罗士/FELLOWS',
  '莱克' : '莱克',
  '西屋' : '西屋/Westinghouse',
  '贝昂' : '贝昂',
  '远大' : '远大',
  '霍尼韦尔' : '霍尼韦尔/Honeywell',
  '飞利浦' : '飞利浦/Philips',
  '龙禹' : '龙禹',
};

var Product = Backbone.Model.extend({
  urlRoot: "products"
});

var Products = Backbone.Collection.extend({
  url: function() {
    var params = {
      room_size: this.room_size,
      brand: this.brand,
      mode: this.search_mode,
      page: this.page
    };

    var paramsStr = _.map(params, function(value, key){
      return key + "=" + value;
    }).join("&");

    return "/suggest?" + paramsStr;
  },
  page: 1,
  room_size: 15,
  brand: "所有品牌",
  search_mode: "suggest",
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

    if($("#suggest-product").hasClass("active")) {
      this.products.search_mode = "suggest";
      this.products.room_size = $("#room_size").val();
    } else {
      this.products.search_mode = "search";
      this.products.brand = $("#brand").val();
    }

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
      { href: "#search", text: "天朗气清", active: true }
    ]);
    this.updateView("#content",
      new SearchBarView({ products: this.products }));
    console.log("show search bar");
  },

  showSearchResults: function() {
    breadcrumbView.updateView([
      { href: "#search", text: "天朗气清" }, 
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
          { href: "#search", text: "天朗气清" }, 
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
    return this.products.room_size + "m² + " +
      this.products.brand;
  }
});

var breadcrumbView = new BreadcrumbView();
var router = new AppRouter();
Backbone.history.start();
