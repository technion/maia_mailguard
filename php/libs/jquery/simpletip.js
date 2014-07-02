/*
 * jQuery simpleTip plugin
 * Version 0.1  (12/06/2008)
 * @requires jQuery v1.2.6+
 * @author Karl Swedberg
 * @author David Morton
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 * modified by David Morton to display other local elements
 *
 * @method :
 * .simpletip(target, options)
 *
 * @arguments : 
 * 
 **  @target (selector string) mandatory
 **     
 **  @options (object) optional
 **     opacity: 1,  // float. number between 0.1 and 1.0. level of opacity of the tooltip
 **     xOffset: 10, // integer. pixels to the right of the mouse that the left edge tooltip will be displayed
 **     yOffset: 20, // integer.  pixels above or below the mouse that the top of the tooltip will be displayed 
 **     idprefix: 'tip' // string. used to prefix the target's id to find the resulting id of element to display.
 * 
 * @example $('table').simpletip('a', {idprefix: 'tip_'});
 * @description This example shows a tooltip for every link ('a') inside a table. It takes the id of the a element, 
 *  prepends 'tip_', and looks for that id for the data
 * 
 */


;(function($) {
$.fn.simpletip = function(selector, options) {
  var opts = $.extend({}, $.fn.simpletip.defaults, options);

  var $vsTip = $('<div class="simple-tip ui-widget ui-widget-content ui-corner-all ui-state-highlight"></div>')
    .css('opacity', opts.opacity)
    .hide()
    .appendTo('body');

  var tgt,
  tip = {
    link: function(e) {
      var t = $(e.target).is(selector) && e.target || $(e.target).parents(selector)[0] || false;
      return t;
    }
  };

  return this.each(function() {
    var $this = $(this),
    tipContents = '';
    var o = $.meta ? $.extend({}, opts, $this.data()) : opts;

    $this.mouseover(function(event) {
     if (tgt = tip.link(event)) {
      o.contents = $('#' + o.idprefix + tgt.id).html();

       $vsTip.css({
         left: event.pageX + o.xOffset,
         top: event.pageY + o.yOffset
       }).html(o.contents).show();
     }
    }).mouseout(function(event) {
      if (tgt = tip.link(event)) {
        $vsTip.hide();
      }
    }).mousemove(function(event) {
      if (tip.link(event)) {
        $vsTip.css({
          left: event.pageX + o.xOffset,
          top: event.pageY + o.yOffset
        });
      }        
    });

  });

};

// default options
$.fn.simpletip.defaults = {
  opacity: 1,
  xOffset: 10,
  yOffset: 20,
  idprefix: 'tip_'
};

})(jQuery);

