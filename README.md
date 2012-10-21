acc-wizard
==========

An accordion-based wizard based on Bootstrap styles.

This wizard is implemented as a jQuery plugin. Include the appropriate CSS and javascript files in your HTML, and then activate the wizard by calling it, e.g.

    $(window).load(function() {
                $(".acc-wizard").accwizard();
    })

For a demonstration and example usage, see [here](http://sathomas.me/acc-wizard/).

The plugin accepts options as a single object argument. Supported options are:

* **addButtons** add next/prev buttons to panels (default: true)
* **sidebar** selector for task sidebar (default: ".acc-wizard-sidebar")
* **activeClass** class to indicate the active task in sidebar (default: "acc-wizard-active")
* **completedClass** class to indicate task is complete (default: "acc-wizard-completed")
* **todoClass** class to indicate task is still pending (default: "acc-wizard-todo")
* **stepClass** class for step buttons within panels (default: "acc-wizard-step")
* **nextText** text for next button (default: "Next Step")
* **backText** text for back button (default: "Go Back")
* **nextType** HTML input type for next button (default: "submit")
* **backType** HTML input type for back button (default: "reset")
* **nextClasses** class(es) for next button (default: "btn btn-primary")
* **backClasses** class(es) for back button (default: "btn")
* **onNext** function to call on next step
* **onBack** function to call on back up
* **onInit** a chance to hook initialization
* **onDestroy** a chance to hook destruction
