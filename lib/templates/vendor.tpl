<script>
	CodeMirror.defaults.lineNumbers = true;
	CodeMirror.defaults.matchBrackets = true;
	CodeMirror.defaults.readOnly = true;
	CodeMirror.defaults.theme = '<%= codeMirror.theme %>';
	CodeMirror.defaults.viewportMargin = Infinity;
	CodeMirror.defaults.tabSize = 2;

	var REGEX_LB = /&#123;/g;

	var REGEX_RB = /&#125;/g;

	function disposePageComponent() {lb}
		if (window.prevElectricPageComponent) {lb}
			window.prevElectricPageComponent.dispose();
		{rb}
	{rb}

	function runCodeMirror() {lb}
		var code = document.querySelectorAll('.code');

		for (var i = 0; i < code.length; i++) {lb}
			// Workaround for soy issue where namespace and template tags are
			// rendered inside literal blocks
			var text = code[i].innerText
				.replace(REGEX_LB, '{lb}')
				.replace(REGEX_RB, '{rb}');

			var editor = CodeMirror(function(elt) {lb}
				var preEl = code[i].parentNode;

				preEl.parentNode.append(elt);
			{rb}, {lb}
				mode: code[i].getAttribute('data-mode') || '',
				value: text
			{rb});
		{rb}

		new metal.ElectricCodeTabs();
	{rb}

	function runGoogleAnalytics(path) {lb}
		if (ga) {lb}
			ga('set', 'page', path);
			ga('send', 'pageview');
		{rb}
	{rb}

	runCodeMirror();

	document.addEventListener('DOMContentLoaded', function() {lb}
		if (senna) {lb}
			var app = senna.dataAttributeHandler.getApp();
			app.on('endNavigate', function(event) {lb}
				disposePageComponent();
				runCodeMirror();
				runGoogleAnalytics(event.path);
			{rb});
		{rb}
	{rb});

	<% if (googleAnalytics) { %>
		(function(i,s,o,g,r,a,m){lb}i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){lb}
		(i[r].q=i[r].q||[]).push(arguments){rb},i[r].l=1*new Date();a=s.createElement(o),
		m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		{rb})(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

		ga('create', '<%= googleAnalytics %>', 'auto');
		ga('send', 'pageview');
	<% } %>
</script>
