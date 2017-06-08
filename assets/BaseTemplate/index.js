
module.exports = {

    name: "Base template",

    directory: false,

    params: [
      { name: "Name", default: "Default name"},
      { name: "Body", default: ""}
    ],

    rules: function(config) {

      return({
        items: [
          { destinationFile: "index.html",           sourceTemplateFile: "index.template"    },
          { destinationFile: "images/someimage.jpg", sourceContentFile: "img/someimage.jpg" }
        ]
      });

    }

}
