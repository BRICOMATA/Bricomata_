function trackEventsArticle(page, type){
		var track = "";
		switch (type) {
			case "references":
				track = "article-page:references";
				break;
			case "citations":
				track = "article-page:citations";
				break;
			case "footnotes":
				track = "article-page:footnotes";
				break;
			case "related-journal":
				track = "article-page:related-journal-follow";
				break;
		}
		pageDataTracker.trackEvent('conversionDriverClick', {conversionDriver:{name : track}});
		if (type == 'related-journal') {
			window.location.href = page;
		} else {
			window.open(page,'_blank');
		}
};

$(document).ready(function() {
	var $sugCitation = $('.suggested-citation'),
	$selection = $('#selection');

	$sugCitation
		.on('click', function(ev) {
			if (!$(ev.target).is('a')) {
				var el = $sugCitation[0];
				selectAll(el);
			}
		});

	$('.suggested-citation-btn').on('click', function(ev) {
		ev.preventDefault();
		$(this).toggleClass('open');
		$('.suggested-citation').slideToggle();
	});

	$('.show-contact-btn').on('click', function(ev) {
		ev.preventDefault();
		$(this).toggleClass('open');
		$('.contact-information').slideToggle();
	});

	$('.star-container a').on('click', function(ev) {
		ev.preventDefault();
		var $icon = $(this).find('i'),
			userId = $icon.data('user-id'),
			abstractId = $icon.data('abstract-id'),
			url = $icon.data('abstract-url'),
			auth = $icon.data('abstract-auth');
		/*We need to know in which enviroment we are*/
		var pos = url.indexOf("static");
		env = url.substring(0, pos);

		var sActionSend = 'https://' + url + '/cfc/webservices/briefcaseServices.cfc';	
		var message= "";
		var linkText = "";
		if ($icon.hasClass('icon-gizmo-star-fill')) {
			$icon
				.removeClass('icon-gizmo-star-fill')
				.addClass('icon-gizmo-star-outline');
			// Remove fav functionality
			var parameters = {
				"method" : "removeFavPaper",
				"user_id" : userId,
				"ab_id" : abstractId
			};
			pageDataTracker.trackEvent('conversionDriverClick', {conversionDriver:{name : 'article-page:remove-from-briefcase'}});
		} else {
			$icon
			.removeClass('icon-gizmo-star-outline')
			.addClass('icon-gizmo-star-fill');
			// Add fav functionality
			var parameters = {
				"method" : "addFavPaper",
				"user_id" : userId,
				"ab_id" : abstractId
			};
			message = "This article has been added to your library.";
			linkText = "Click here to view all your papers";
			pageDataTracker.trackEvent('conversionDriverClick', {conversionDriver:{name : 'article-page:add-to-my-briefcase'}});
		}

		var briefcaseUrl = "https://" + env + "hq.ssrn.com/Library/myLibrary.cfm"

		if (auth == false && userId == 1) {
			window.location = briefcaseUrl + "?abid="+ abstractId;
		} else {
			$.ajax({
				url : sActionSend,
				type: "POST",
				data : parameters,
				success: function(data, textStatus, jqXHR) {
					if(data.SUCCESS == true){
						if (parameters.method == "addFavPaper") {
							pageDataTracker.trackEvent('saveToList', { 
							    content : [{
							        id : abstractId
							    }]
							});
							showToastr({
								message: message,
								linkUrl: briefcaseUrl,
								linkText: linkText
							});
						}
					}
				},
				error: function (jqXHR, textStatus, errorThrown) {
					console.log(textStatus);
				}
			});
		}
	});

	$('.box-recommended-papers .view-more').on('click', function(ev) {
		ev.preventDefault();
		var hasClass = $(this).hasClass('open');
		$(this).toggleClass('open');
		$('.list-recommended-papers .more').slideToggle(function(){
			var div = $('.box-recommended-papers')[0]
			if (hasClass) {
				$('.box-recommended-papers')[0].scrollIntoView();	
			} else {
				div.scrollTop = div.scrollHeight - div.clientHeight;
			}
		});
	});

	$('#permalink').click(function(e) {
		$('.permalink-tooltip').toggle();
	});

	var isIE = navigator.appName == 'Microsoft Internet Explorer' || !!window.MSInputMethodContext && !!document.documentMode || (navigator.appName == "Netscape" && navigator.appVersion.indexOf('Edge') > -1);
	$('#copyURL').click(function(e) {
		if (isIE) {
			$('#parmalinkURL').select();
			document.execCommand("copy");
		} else {
			selectAllAndCopy($('#parmalinkURL')[0]);
		}
	});

	$('#copyDOI').click(function(e) {	
		if (isIE) {
			$('#parmalinkDOI').select();
			document.execCommand("copy");
		} else {
			selectAllAndCopy($('#parmalinkDOI')[0]);
		}
	});

	$('.box-related-journals .icon-gizmo-information').click(function(ev){
		ev.preventDefault();
		$(this).parent().find('.related-journals-tooltip').show();
	});

	$('.related-journals-tooltip .icon-gizmo-delete').click(function(){
		$(this).closest('.related-journals-tooltip').hide();
	});

	$('.box-related-journals .view-more').on('click', function(ev) {
		ev.preventDefault();
		var div = $($('.quick-links')[0]);
		var nonVisibleRJ = $('.box-related-journals .more').children();
		if(nonVisibleRJ.length > 0 && nonVisibleRJ.length <= 3){
			$('.box-related-journals .view-more').hide();
		}
		for (var i = 0; i < nonVisibleRJ.length; i++) {
			if(i < 3){
				div.append(nonVisibleRJ[i]);
			}
		}
	});
	
	$('.download-button').click(function(e) {
		var ab_id = $(this).data('abstract-id');
		var strAbTitle = $(this).data('abstract-title');
		pageDataTracker.trackEvent('contentDownload', {
		    content : [{
		        format : 'MIME-PDF',
		        id : "" + ab_id + "",
		        title: strAbTitle,
		        type: 'XOCS-JOURNAL:SCOPE-ABSTRACT:PREPRINT'
		    }],
		});
	});
});

$(document).on('click touchstart',function(event) {
	if (!$(event.target).closest('.permalink-tooltip').length && $(event.target)[0] != $('#permalink i')[0]) {
		if ($('.permalink-tooltip').is(":visible")) {
			$('.permalink-tooltip').hide();
		}
	}
});