/*
 jQuery delayed observer - 0.8
 http://code.google.com/p/jquery-utils/

 (c) Maxime Haineault <haineault@gmail.com>
 http://haineault.com
 
 MIT License (http://www.opensource.org/licenses/mit-license.php)
 
*/

(function($){
    $.extend($.fn, {
        delayedObserver: function(callback, delay, options) {
            return this.each(function() {
                var el = $(this);
                var op = options || {};
                
                var timer;
                var oldval = el.val();
                var condition = op.condition || function() {
                    return $(this).val() == oldval;
                }
                delay = delay || 0.5;
                
                function changeHandler() {
                    if (!condition.apply(el)) {
                        if (timer) {
                            clearTimeout(timer);
                        }
                        timer = setTimeout(function() {
                            callback.apply(el);
                        }, delay * 1000);
                        oldval = el.val();
                    }
                }
                
                el.bind(op.event || 'keyup', changeHandler);
            });
        }
    });
})(jQuery);
