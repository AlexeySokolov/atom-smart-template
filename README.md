# atom-smart-template package

Этот пакет-расширение для редактора Atom предназначен для генерации файлов из шаблонов.


Базовые шаблоны находятся в папке:

~/.atom/smart-templates


Шаблоны уровня проекта должны находится в папке:

{{ProjectRoot}}/.smart-templates


Каждый шаблон представляет собой папку c файлами:

~/.atom/smart-templates/my-super-template
index.js (обязательно)
  template1.ejs
  template2.ejs
  template3.ejs


Файл index.js является модулем, который возвращает функцию, которая возвращает массив файлов,
которые нужно сгенерировать. В функция передается объект конфигурация.
[
  {
    path: "index.html",          // Путь будет {{ProjectRoot}}/index.html
    template: "index.ejs"        // Путь будет {{TemplateRoot}}/index.ejs
  },
  {
    path:    "/img/image.jpg",   // Путь будет {{ProjectRoot}}/img/image.jpg
    content: "image.jpg"         // Путь будет {{TemplateRoot}}/image.jpg
  },  
]
