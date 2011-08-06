/*
 * jQuery Form Example Plugin 1.4.2
 * Populate form inputs with example text that disappears on focus.
 *
 * e.g.
 *  $('input#name').example('Bob Smith');
 *  $('input[@title]').example(function() {
 *    return $(this).attr('title');
 *  });
 *  $('textarea#message').example('Type your message here', {
 *    className: 'example_text'
 *  });
 *
 * Copyright (c) Paul Mucur (http://mucur.name), 2007-2008.
 * Dual-licensed under the BSD (BSD-LICENSE.txt) and GPL (GPL-LICENSE.txt)
 * licenses.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */
(function(a){a.fn.example=function(e,c){var d=a.isFunction(e);var b=a.extend({},c,{example:e});return this.each(function(){var f=a(this);if(a.metadata){var g=a.extend({},a.fn.example.defaults,f.metadata(),b)}else{var g=a.extend({},a.fn.example.defaults,b)}if(!a.fn.example.boundClassNames[g.className]){a(window).unload(function(){a("."+g.className).val("")});a("form").submit(function(){a(this).find("."+g.className).val("")});a.fn.example.boundClassNames[g.className]=true}if(a.browser.msie&&!f.attr("defaultValue")&&(d||f.val()==g.example)){f.val("")}if(f.val()==""&&this!=document.activeElement){f.addClass(g.className);f.val(d?g.example.call(this):g.example)}f.focus(function(){if(a(this).is("."+g.className)){a(this).val("");a(this).removeClass(g.className)}});f.change(function(){if(a(this).is("."+g.className)){a(this).removeClass(g.className)}});f.blur(function(){if(a(this).val()==""){a(this).addClass(g.className);a(this).val(d?g.example.call(this):g.example)}})})};a.fn.example.defaults={className:"example"};a.fn.example.boundClassNames=[]})(jQuery);
