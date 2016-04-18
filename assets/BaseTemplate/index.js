
module.exports = {

    name: "Base template",
    
    directory: false,

    params: ["Name", "Body"],

    rules: function(config) {

      return({
        items: [
          { destinationFile: "index.html",           sourceTemplateFile: "index.template"    },
          { destinationFile: "images/someimage.jpg", sourceContentFile: "img/someimage.jpg" }
        ]
      });

    }

}
