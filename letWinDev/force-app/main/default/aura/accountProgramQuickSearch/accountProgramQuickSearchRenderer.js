({
    // Your renderer method overrides go here
    afterRender: function (cmp, helper){
        this.superAfterRender();
        helper.autoFocus(cmp, helper);
    }
})