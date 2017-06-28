var pageSession = new ReactiveDict();

Template.HomePrivateInsert.onCreated(function() {
	
});

Template.HomePrivateInsert.onDestroyed(function() {
	
});

Template.HomePrivateInsert.onRendered(function() {
	
	Meteor.defer(function() {
		globalOnRendered();
		$("input[autofocus]").focus();
	});
});

Template.HomePrivateInsert.events({
	
});

Template.HomePrivateInsert.helpers({
	
});

Template.HomePrivateInsertInsertAudit.onCreated(function() {
	
});

Template.HomePrivateInsertInsertAudit.onDestroyed(function() {
	
});

Template.HomePrivateInsertInsertAudit.onRendered(function() {
	

	pageSession.set("homePrivateInsertInsertAuditInfoMessage", "");
	pageSession.set("homePrivateInsertInsertAuditErrorMessage", "");

	$(".input-group.date").each(function() {
		var format = $(this).find("input[type='text']").attr("data-format");

		if(format) {
			format = format.toLowerCase();
		}
		else {
			format = "mm/dd/yyyy";
		}

		$(this).datepicker({
			autoclose: true,
			todayHighlight: true,
			todayBtn: true,
			forceParse: false,
			keyboardNavigation: false,
			format: format
		});
	});

	$("input[type='file']").fileinput();
	$("select[data-role='tagsinput']").tagsinput();
	$(".bootstrap-tagsinput").addClass("form-control");
	$("input[autofocus]").focus();
});

Template.HomePrivateInsertInsertAudit.events({
	"submit": function(e, t) {
		e.preventDefault();
      
		pageSession.set("homePrivateInsertInsertAuditInfoMessage", "");
		pageSession.set("homePrivateInsertInsertAuditErrorMessage", "");

		var self = this;

		function submitAction(result, msg) {
			var homePrivateInsertInsertAuditMode = "insert";
			if(!t.find("#form-cancel-button")) {
				switch(homePrivateInsertInsertAuditMode) {
					case "insert": {
						$(e.target)[0].reset();
					}; break;

					case "update": {
						var message = msg || "Saved.";
						pageSession.set("homePrivateInsertInsertAuditInfoMessage", message);
					}; break;
				}
			}
          
          
          	console.log('nuova attività',result);
          	
            var current_tipo= Activities.findOne({_id:result}).tipo;                             
              
            switch(Activities.findOne({_id:result}).tipo) { 	
              						case "Audit": Router.go("audits.workflow", mergeObjects(Router.currentRouteParams(), {})); break; 
              					  	case "Informativa": Router.go("informativa.workflow", mergeObjects(Router.currentRouteParams(), {})); break; 
              						case "Audit Filiale": Router.go("audit_filiale.workflow", mergeObjects(Router.currentRouteParams(), {})); break; }
			}

		function errorAction(msg) {
			msg = msg || "";
			var message = msg.message || msg || "Error.";
			pageSession.set("homePrivateInsertInsertAuditErrorMessage", message);
		}

		validateForm(
			$(e.target),
			function(fieldName, fieldValue) {

			},
			function(msg) {

			},
			function(values) {
             	                values.data = moment().format('MM/DD/YYYY');
			console.log(values.data);
                                values.auditors = Meteor.user();
			console.log('a',values.auditors);
                                values.status = "Avviato";                               	

                    Meteor.call("activitiesInsert", values, function(e, r) { if(e) errorAction(e); else submitAction(r); });
			}
		);

		return false;
	},
	"click #form-cancel-button": function(e, t) {
		e.preventDefault();

		

		/*CANCEL_REDIRECT*/
	},
	"click #form-close-button": function(e, t) {
		e.preventDefault();

		/*CLOSE_REDIRECT*/
	},
	"click #form-back-button": function(e, t) {
		e.preventDefault();

		/*BACK_REDIRECT*/
	}

	
});

Template.HomePrivateInsertInsertAudit.helpers({
	"infoMessage": function() {
		return pageSession.get("homePrivateInsertInsertAuditInfoMessage");
	},
	"errorMessage": function() {
		return pageSession.get("homePrivateInsertInsertAuditErrorMessage");
	}
	
});
