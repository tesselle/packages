/* from https://github.com/r-lib/pkgdown/blob/master/inst/assets/BS4/pkgdown.js */
/* http://gregfranko.com/blog/jquery-best-practices/ */
(function($) {
  $(function() {

    /* Search --------------------------*/
    /* Adapted from https://github.com/rstudio/bookdown/blob/2d692ba4b61f1e466c92e78fd712b0ab08c11d31/inst/resources/bs4_book/bs4_book.js#L25 */
    // Initialise search index on focus
    var fuse;
    $("#search-references").focus(async function(e) {
      if (fuse) {
        return;
      }

      $(e.target).addClass("loading");
      var response = await fetch($("#search-references").data("search-index"));
      var data = await response.json();

      var options = {
        keys: ["what", "text", "code"],
        ignoreLocation: true,
        threshold: 0.1,
        includeMatches: true,
        includeScore: true,
      };
      fuse = new Fuse(data, options);

      $(e.target).removeClass("loading");
    });

    // Use algolia autocomplete
    var options = {
      autoselect: true,
      debug: true,
      hint: false,
      minLength: 2,
    };
    var q;
    async function searchFuse(query, callback) {
      await fuse;

      var items;
      if (!fuse) {
        items = [];
      } else {
        q = query;
        var results = fuse.search(query, { limit: 20 });
        items = results
          .filter((x) => x.score <= 0.75)
          .map((x) => x.item);
        if (items.length === 0) {
          items = [
            {
              package:"tesselle",
              title:"Sorry 😿",
              text:"No results found.",
              path:window.location.href
            }
          ];
        }
      }
      callback(items);
    }
    $("#search-references").autocomplete(options, [
      {
        name: "content",
        source: searchFuse,
        templates: {
          suggestion: (s) => {
            if (s.text != "") {
              return `${s.package} > ${s.title} > <div class="search-details">${s.text}</div>`;
            } else {
              return `${s.package} > <div class="search-details"> ${s.title}</div>`;
            }
          },
        },
      },
    ]).on('autocomplete:selected', function(event, s) {
      window.location.href = s.path + "?q=" + q + "#" + s.id;
    });
  });
})(window.jQuery || window.$)
