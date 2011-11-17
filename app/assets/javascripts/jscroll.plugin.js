/*
 * jscroll Plugin
 * version: 1.0.0
 * 
 *Examples and documentation at: http://www.unicodesystems.in/jquery/jscroll
 * Copyright (c) 2010 Unicode Systems (www.unicodesystems.in)
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Date: 25-oct-2010
 * http://plugins.jquery.com/project/jscroll
 */
(function($){
    $.fn.jscroll=function(options){
        var settings={
            duration:2000
        };
        return this.each(function(){
            var $this=$(this);
            var slides=$this.children();
            var current=0;
            var td;
            if(options){
                $.extend(settings,options);
            }
            var scrollIt=function(){
                if(slides!=undefined && slides.length>0){
                    $(slides[current]).fadeTo('slow',.01,function(){
                        $(this).slideUp('slow',function(){
                            $(this).remove();
                            $this.append($(this));
                            $(this).show(10);
                            $(this).fadeTo(10,1.0);
                            current++;
                            if(current>=slides.length){
                                current=0;
                            }
                            setTimeout(scrollIt,settings.duration);
                        });
                    });
                }
            };
            $this.hover(function(){
                if(td){
                    clearTimeout(td);
                    $(slides[current]).stop();
                }
            }, function(){
                start();
            });
            var start=function(){
                td=setTimeout(scrollIt,settings.duration);
            }
            start();
        });
    };
})(jQuery);