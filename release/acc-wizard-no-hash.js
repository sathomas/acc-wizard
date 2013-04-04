/*!
 * jQuery plug-in to implement an accordion wizard based on bootstrap
 * Original author: @stephen_thomas
 * Plugin Boilerplate: http://coding.smashingmagazine.com/2011/10/11/essential-jquery-plugin-patterns/
 * Additional Boilerplate: http://f6design.com/journal/2012/05/06/a-jquery-plugin-boilerplate/
 * Comments from boilerplate sources retained
 * Licensed under the MIT license
 */
// the semi-colon before the function invocation is a safety
// net against concatenated scripts and/or other plugins
// that are not closed properly.
(function (e, t, n, r) {
    function s(n, s) {
        function f(t) {
            if (t && t.length > 1) {
                e(s.sidebar, u).children("li").children("a[href='" + t + "']").parent("li").addClass(s.activeClass);
                e(s.sidebar, u).children("li").children("a[href!='" + t + "']").parent("li").removeClass(s.activeClass)
            }
        }
        function l() {
            if (s.addButtons) {
                var n = e("<div/>", {
                    "class": s.stepClass
                }).append(e("<button/>", {
                    "class": s.nextClasses,
                    type: s.nextType,
                    text: s.nextText
                })),
                    r = e("<div/>", {
                        "class": s.stepClass
                    }).append(e("<button/>", {
                        "class": s.backClasses,
                        type: s.backType,
                        text: s.backText
                    })).append(" ").append(e("<button/>", {
                        "class": s.nextClasses,
                        type: s.nextType,
                        text: s.nextText
                    })),
                    i = e(".accordion-body .accordion-inner form", u),
                    o = i.length - 1;
                for (var l = 0; l < o; l++) l === 0 ? e(i[0]).append(n) : e(i[l]).append(e(r).clone())
            }
            a = t.location.hash || e(s.sidebar, u).children("li." + s.todoClass + ":first").children("a").attr("href") || e(s.sidebar, u).children("li:first").children("a").attr("href");
            /*t.location.hash = a;*/
            var c = "#" + e(".accordion", u)[0].id;
            e(".collapse", u).each(function () {
                "#" + this.id === a ? e(this).hasClass("in") ? e(this).collapse({
                    parent: c,
                    toggle: !1
                }) : e(this).collapse({
                    parent: c,
                    toggle: !0
                }) : e(this).hasClass("in") ? e(this).collapse({
                    parent: c,
                    toggle: !0
                }) : e(this).collapse({
                    parent: c,
                    toggle: !1
                })
            });
            f(a);
            /*e(t).bind("hashchange", function () {
                if (a !== t.location.hash) {
                    //a = t.location.hash;
                    e(".accordion-body" + a, u).collapse("show");
                    f(a)
                }
            });*/
            e(".accordion-body", u).on("shown", function () {
                a = "#" + this.id;
                f(a);
                //t.location.hash = a
            });
            if (s.addButtons) {
                e("." + s.stepClass, u).children("button[type='" + s.nextType + "']").click(function (t) {
                    t.preventDefault();
                    var n = e(this).parents(".accordion-body")[0],
                        r = "#" + e(".accordion-body", e(n).parents(".accordion-group").next(".accordion-group")[0])[0].id;
                    e(r).collapse("show");
                    p("onNext", n)
                });
                e("." + s.stepClass, u).children("button[type='" + s.backType + "']").click(function (t) {
                    t.preventDefault();
                    var n = e(this).parents(".accordion-body")[0],
                        r = "#" + e(".accordion-body", e(n).parents(".accordion-group").prev(".accordion-group")[0])[0].id;
                    e(r).collapse("show");
                    p("onPrev", n)
                })
            }
            p("onInit")
        }
        function c(e, t) {
            if (!t) return s[e];
            s[e] = t
        }
        function h() {
            p("onDestroy")
        }
        function p(e) {
            if (s[e] !== r) {
                var t = s[e];
                arguments[0] = o;
                t.apply(this, arguments)
            }
        }
        var o = n,
            u = e(n),
            a;
        s = e.extend({}, e.fn[i].defaults, s);
        l();
        return {
            option: c,
            destroy: h
        }
    }
    var i = "accwizard";
    e.fn[i] = function (t) {
        if (typeof arguments[0] == "string") {
            var n = arguments[0],
                o = Array.prototype.slice.call(arguments, 1),
                u;
            this.each(function () {
                if (!e.data(this, "plugin_" + i) || typeof e.data(this, "plugin_" + i)[n] != "function") throw new Error("Method " + n + " does not exist on jQuery." + i);
                u = e.data(this, "plugin_" + i)[n].apply(this, o)
            });
            return u !== r ? u : this
        }
        if (typeof t == "object" || !t) return this.each(function () {
                e.data(this, "plugin_" + i) || e.data(this, "plugin_" + i, new s(this, t))
            })
    };
    e.fn[i].defaults = {
        addButtons: !0,
        sidebar: ".acc-wizard-sidebar",
        activeClass: "acc-wizard-active",
        completedClass: "acc-wizard-completed",
        todoClass: "acc-wizard-todo",
        stepClass: "acc-wizard-step",
        nextText: "Next Step",
        backText: "Go Back",
        nextType: "submit",
        backType: "reset",
        nextClasses: "btn btn-primary",
        backClasses: "btn",
        onNext: function () {},
        onBack: function () {},
        onInit: function () {},
        onDestroy: function () {}
    }
})(jQuery, window, document);