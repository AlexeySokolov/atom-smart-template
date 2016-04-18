# atom-smart-template package

The package is designed for quick and easy creation of file or multiple files and directories from a template using parameters.

## How to use
Use the command "Create files from template" from the context menu of the file tree.

<a href="http://www.youtube.com/watch?v=jfm30wRNL1o">
<img src="https://raw.githubusercontent.com/AlexeySokolov/atom-smart-template/master/assets/atom-smart-templates-files-creation-yt.png" width="420" height="315" >
</a>

## How to create new template

<a href="http://www.youtube.com/watch?v=mCuzvBaPWEo">
<img src="https://raw.githubusercontent.com/AlexeySokolov/atom-smart-template/master/assets/how-to-create-new-template-yt.png" width="560" height="315" >
</a>

The main file of template is "index.js":

```js
module.exports = {

    name: "Base template",

    params: ["Name", "Body"],

    directory: false,

    rules: function(config) {

      return({
        items: [
          { destinationFile: "index.html",           sourceTemplateFile: "index.template"    },
          { destinationFile: "images/someimage.jpg", sourceContentFile: "img/someimage.jpg" }
        ]
      });

    }

}
```

The ```rules``` function has a ```config``` parameter  which contains the values entered by the user when creating the template. You can use these values to generate the names and content of destination files. Also you can simply copy the files from your template (```sourceContentFile```) to the target folder without processing.

Optional directory property to template options. If enabled, while creating files from template, there will be a parent directory created as well. It's name will be same as the "Name" parameter set - if available.
Otherwise, it'll take the name of the template itself.
