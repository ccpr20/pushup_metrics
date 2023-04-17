$(document).on('turbolinks:load', function() {

  var Charts = {

    _HYPHY_REGEX: /-([a-z])/g,

    _cleanAttr: function (obj) {
      delete obj["chart"]
      delete obj["value"]
      delete obj["labels"]
    },

    doughnut: function (element) {
      var attrData = $.extend({}, $(element).data())
      var data     = eval(attrData.value)

      Charts._cleanAttr(attrData)

      var options = $.extend({
        responsive: true,
        animation: false,
        segmentStrokeColor: '#fff',
        segmentStrokeWidth: 2,
        percentageInnerCutout: 80,
      }, attrData)

      new Chart(element.getContext('2d')).Doughnut(data, options)
    },

    bar: function (element) {
      var attrData = $.extend({}, $(element).data())

      var data = {
        labels   : eval(attrData.labels),
        datasets : eval(attrData.value).map(function (set, index) {
          return $.extend({
            fillColor   : ('grey'),
            strokeColor : 'transparent'
          }, set)
        })
      }

      Charts._cleanAttr(attrData)

      var options = $.extend({
        responsive: true,
        animation: true,
        scaleShowVerticalLines: false,
        scaleOverride: true,
        barValueSpacing: 5,
        scaleFontColor: 'rgba(0,0,0,.4)',
        scaleFontSize: 14,
        scaleLineColor: 'rgba(0,0,0,.05)',
        scaleGridLineColor: 'rgba(0,0,0,.05)',
        barDatasetSpacing: 2
      }, attrData)

      new Chart(element.getContext('2d'), {type: 'bar', data: data, options: options})
    },

    line: function (element) {
      var attrData = $.extend({}, $(element).data())

      var data = {
        labels   : eval(attrData.labels),
        datasets : eval(attrData.value).map(function (set) {
          return $.extend({
            fillColor: 'rgba(66, 165, 245, .2)',
            strokeColor: '#42a5f5',
            pointStrokeColor: '#fff'
          }, set)
        })
      }

      Charts._cleanAttr(attrData)

      var options = $.extend({
        animation: true,
        responsive: true,
        bezierCurve : true,
        bezierCurveTension : 0.25,
        scaleShowVerticalLines: false,
        pointDot: false,
        tooltipTemplate: "<%= value %>",
        scaleOverride: true,
        scaleLineColor: 'rgba(0,0,0,.05)',
        scaleGridLineColor: 'rgba(0,0,0,.05)',
        scaleFontColor: 'rgba(0,0,0,.4)',
        scaleFontSize: 14,
        scaleLabel: function (label) {
          return label.value.replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")
        }
      }, attrData)
      new Chart(element.getContext('2d'), {type: 'line', data: data, options: options})
    },

    'spark-line': function (element) {
      var attrData = $.extend({}, $(element).data())

      var data = {
        labels   : eval(attrData.labels),
        datasets : eval(attrData.value).map(function (set) {
          return $.extend({
            fillColor: 'rgba(255,255,255,.3)',
            strokeColor: '#fff',
            pointStrokeColor: '#fff'
          }, set)
        })
      }

      Charts._cleanAttr(attrData)

      var options = $.extend({
        animation: false,
        responsive: true,
        bezierCurve : true,
        bezierCurveTension : 0.25,
        showScale: false,
        pointDotRadius: 0,
        pointDotStrokeWidth: 0,
        pointDot: false,
        showTooltips: false
      }, attrData)
      new Chart(element.getContext('2d'), {type: 'line', data: data, options: options})
    }
  }

  $(document)
    .on('redraw.bs.charts', function () {
      $('[data-chart]').each(function () {
        if ($(this).is(':visible')) {
          Charts[$(this).attr('data-chart')](this)
        }
      })
    })
    .trigger('redraw.bs.charts')
});
