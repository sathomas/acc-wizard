#!
# * jQuery plug-in to implement an accordion wizard based on bootstrap
# * Original author: @stephen_thomas
# * Plugin Boilerplate: http://coding.smashingmagazine.com/2011/10/11/essential-jquery-plugin-patterns/
# * Additional Boilerplate: http://f6design.com/journal/2012/05/06/a-jquery-plugin-boilerplate/
# * Comments from boilerplate sources retained
# * Licensed under the MIT license
# 

# the semi-colon before the function invocation is a safety
# net against concatenated scripts and/or other plugins
# that are not closed properly.
(($, window, document, undefined_) ->
  # undefined is used here as the undefined global
  # variable in ECMAScript 3 and is mutable (i.e. it can
  # be changed by someone else). undefined isn't really
  # being passed in so we can ensure that its value is
  # truly undefined. In ES5, undefined can no longer be
  # modified.
  
  # window and document are passed through as local
  # variables rather than as globals, because this (slightly)
  # quickens the resolution process and can be more
  # efficiently minified (especially when both are
  # regularly referenced in your plugin).
  
  # From http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/
  #
  # Strict Mode is a new feature in ECMAScript 5 that allows you to
  # place a program, or a function, in a "strict" operating context.
  # This strict context prevents certain actions from being taken
  # and throws more exceptions (generally providing the user with
  # more information and a tapered-down coding experience).
  #
  # Since ECMAScript 5 is backwards-compatible with ECMAScript 3,
  # all of the "features" that were in ECMAScript 3 that were
  # "deprecated" are just disabled (or throw errors) in strict
  # mode, instead.
  #
  # Strict mode helps out in a couple ways:
  #
  #  *  It catches some common coding bloopers, throwing exceptions.
  #  *  It prevents, or throws errors, when relatively "unsafe"
  #     actions are taken (such as gaining access to the global object).
  #  *  It disables features that are confusing or poorly thought out.
  
  #    "use strict";
  
  # The plug-in itself is implemented as an object. Here's the
  # constructor function
  Plugin = (element, options) ->
    # Members
    # DOM version of element
    # jQuery version of element
    # track the window hash
    
    # Extend default options with those supplied by user.
    
    # Make a specific task active in the sidebar
    makeTaskActive = (hash) ->
      if hash and hash.length > 1
        # Add class to appropriate task
        $(options.sidebar, $el).children("li").children("a[href='" + hash + "']").parent("li").addClass options.activeClass
        
        # Remove class from other tasks
        $(options.sidebar, $el).children("li").children("a[href!='" + hash + "']").parent("li").removeClass options.activeClass
    
    # Mark a specific task as completed in the sidebar
    #function completeTask(hash) {
    #    if (hash && hash.length > 1) {
    #        $(options.sidebar,$el).children("li a[href='" + hash + "']")
    #            .parent("li").removeClass(options.todoClass)
    #            .addClass(options.completedClass);
    #    }
    #}
    # Mark a specific task as not complete in the sidebar
    #function uncompleteTask(hash) {
    #    if (hash && hash.length > 1) {
    #        $(options.sidebar,$el).children("li a[href='" + hash + "']")
    #            .parent("li").removeClass(options.completedClass)
    #            .addClass(options.todoClass);
    #    }
    #}
    
    # Initialize plugin.
    init = ->
      # We assume that the page is delivered by the server in a form
      # that can be used without any javascript. Since we're running,
      # javascript must be available. So the first thing we do is
      # make adjustments to the page that convert it from HTML-only
      # to HTML+javascript.
      #
      # Because the "Go Back" and "Next Step" buttons don't make
      # sense unless Javascript is available, the page shouldn't
      # include them by default. That way, users without
      # javascript won't see them. Since we have javascript,
      # however, we can add them now.
      #
      # Construct the appropriate elements using plugin options
      # so callers can override if appropriate
      if options.addButtons
        nextOnly = $("<div/>",
          class: options.stepClass
        ).append($("<button/>",
          class: options.nextClasses
          type: options.nextType
          text: options.nextText
        ))
        nextBack = $("<div/>",
          class: options.stepClass
        ).append($("<button/>",
          class: options.backClasses
          type: options.backType
          text: options.backText
        )).append(" ").append($("<button/>",
          class: options.nextClasses
          type: options.nextType
          text: options.nextText
        ))
        
        # Grab all the <form> elements in the accordion stack
        # and count them.
        forms = $(".accordion-body .accordion-inner form", $el)
        last = forms.length - 1
        
        # We deliberately skip the last form element because
        # that should be the confirm button for the whole page
        ix = 0

        while ix < last
          if ix is 0
            $(forms[0]).append nextOnly
          else
            $(forms[ix]).append $(nextBack).clone()
          ix++
      
      # Now that our HTML is updated for javascript, let's
      # tackle the window hash. Research indicates that users
      # of a multi-part accordion create a mental model in
      # which each panel of the accordion is like a separate
      # web page. As a consequence, they expect the browser's
      # back and forward buttons to step through the accordion
      # panels. To accommodate them, we'll need to get our
      # hands a little dirty with the history object and
      # window hashes.
      
      # Figure out which accordion panel should be active. If the URL
      # includes a hash, that's the active panel. Otherwise, we assume
      # the first panel that isn't complete is the active panel. If none
      # of the steps are marked as complete, then use the first step.
      currentHash = window.location.hash or $(options.sidebar, $el).children("li." + options.todoClass + ":first") \
                    .children("a").attr("href") or $(options.sidebar, $el).children("li:first").children("a").attr("href")
      
      # Sync up the window hash with our calculated value
      window.location.hash = currentHash
      
      # We also need to know the overall parent for the panels
      parent = "#" + $(".accordion", $el)[0].id
      
      # Scan through all the .collapse elements, calling collapse()
      # on them to prime the bootstrap data. We show the current
      # hash and hide the others, doing so via the toggle option.
      # The .in class determines whether or not the panel is
      # already visible, and we toggle the visibility or not as
      # appropriate.
      $(".collapse", $el).each ->
        if ("#" + @id) is currentHash
          if $(this).hasClass("in")
            $(this).collapse
              parent: parent
              toggle: false
          else
            $(this).collapse
              parent: parent
              toggle: true
        else if $(this).hasClass("in")
          $(this).collapse
            parent: parent
            toggle: true
        else
          $(this).collapse
            parent: parent
            toggle: false
      
      # And mark the current panel as active in the task list
      makeTaskActive currentHash
      
      # Next up are the events we need to hook. To continue
      # with the hash theme, here's our hook for hash
      # changes.
      $(window).bind "hashchange", ->
        if currentHash isnt window.location.hash
          currentHash = window.location.hash
          $(".accordion-body" + currentHash, $el).collapse "show"
          makeTaskActive currentHash
      
      # Whenever a new accordion panel is shown, update
      # the vertical navigation task list to make
      # the current panel the active task.
      $(".accordion-body", $el).on "shown", ->
        currentHash = "#" + @id
        makeTaskActive currentHash
        window.location.hash = currentHash

      if options.addButtons
        # When the user clicks the "Next" button in
        # any panel, advance to the next panel.
        $("." + options.stepClass, $el).children("button[type='" + options.nextType + "']").click (ev) ->
          ev.preventDefault()
          panel = $(this).parents(".accordion-body")[0]
          next = "#" + $(".accordion-body", $(panel).parents(".accordion-group").next(".accordion-group")[0])[0].id
          $(next).collapse "show"
          hook "onNext", panel

        # When the user clicks the "Back" button in
        # any panel, retrurn to the previous panel.
        $("." + options.stepClass, $el).children("button[type='" + options.backType + "']").click (ev) ->
          ev.preventDefault()
          panel = $(this).parents(".accordion-body")[0]
          prev = "#" + $(".accordion-body", $(panel).parents(".accordion-group").prev(".accordion-group")[0])[0].id
          $(prev).collapse "show"
          hook "onPrev", panel
      
      # Finally, if any caller has hooked our initialization,
      # accommodate it.
      hook "onInit"
    
    # Get/set a plugin option.
    # Get usage: $('#el').acc-wizard('option', 'key');
    # Set usage: $('#el').acc-wizard('option', 'key', value);
    option = (key, val) ->
      if val
        options[key] = val
      else
        options[key]
    
    # Destroy plugin.
    # Usage: $('#el').acc-wizard('destroy');
    destroy = ->
      hook "onDestroy"
    
    # Callback hooks.
    # Usage: In the defaults object specify a callback function:
    # hookName: function() {}
    # Then somewhere in the plugin trigger the callback:
    # hook('hookName');
    hook = (hookName) ->
      if options[hookName] isnt `undefined`
        # Call the user defined function.
        # Scope is set to the jQuery element we are operating on.
        fn = options[hookName]
        arguments[0] = el
        fn.apply this, arguments

    el = element
    $el = $(element)
    currentHash = undefined
    options = $.extend({}, $.fn[pluginName].defaults, options)
    
    # Initialize the plugin instance.
    init()
    
    # Expose methods of Plugin we wish to be public.
    option: option
    destroy: destroy

  pluginName = "accwizard"
  # Build the plugin here
  $.fn[pluginName] = (options) ->
    # If the first parameter is a string, treat this as a call to
    # a public method. The first parameter is the method name and
    # following parameters are arguments for the method.
    if typeof arguments[0] is "string"
      methodName = arguments[0]
      args = Array::slice.call(arguments, 1)
      returnVal = undefined
      @each ->
        # Check that the element has a plugin instance, and that
        # the requested public method exists.
        if $.data(this, "plugin_" + pluginName) and typeof $.data(this, "plugin_" + pluginName)[methodName] is "function"
          # Call the method of the Plugin instance, and pPass it
          # the supplied arguments.
          returnVal = $.data(this, "plugin_" + pluginName)[methodName].apply(this, args)
        else
          throw new Error("Method " + methodName + " does not exist on jQuery." + pluginName)

      if returnVal isnt `undefined`        
        # If the method returned a value, return the value.
        returnVal
      else       
        # Otherwise, returning 'this' preserves chainability.
        this
    # If the first parameter is an object (options), or was omitted,
    # instantiate a new instance of the plugin.
    else if typeof options is "object" or not options
      @each ->
        # Only allow the plugin to be instantiated once.
        # Pass options to Plugin constructor, and store Plugin
        # instance in the element's jQuery data object.
        $.data this, "plugin_" + pluginName, new Plugin(this, options)  unless $.data(this, "plugin_" + pluginName)

  # Default plugin options.
  # Options can be overwritten when initializing plugin, by
  # passing an object literal, or after initialization:
  # $('#el').acc-wazard('option', 'key', value);
  $.fn[pluginName].defaults =
    addButtons: true                             # add next/prev buttons to panels
    sidebar: ".acc-wizard-sidebar"               # selector for task sidebar
    activeClass: "acc-wizard-active"             # class to indicate the active task in sidebar
    completedClass: "acc-wizard-completed"       # class to indicate task is complete
    todoClass: "acc-wizard-todo"                 # class to indicate task is still pending
    stepClass: "acc-wizard-step"                 # class for step buttons within panels
    nextText: "Next Step"                        # text for next button
    backText: "Go Back"                          # text for back button
    nextType: "submit"                           # HTML input type for next button
    backType: "reset"                            # HTML input type for back button
    nextClasses: "btn btn-primary"               # class(es) for next button
    backClasses: "btn"                           # class(es) for back button
    onNext: -> true                              # function to call on next step
    onBack: -> true                              # function to call on back up
    onInit: -> true                              # a chance to hook initialization
    onDestroy: -> true                           # a chance to hook destruction
) jQuery, window, document