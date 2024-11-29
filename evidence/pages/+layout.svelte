<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';

	// UIkit imports from node_modules
	import 'uikit/dist/css/uikit.min.css';
	import UIkit from 'uikit';
	import Icons from 'uikit/dist/js/uikit-icons';

	// Initialize UIkit icons
	UIkit.use(Icons);

	export let data;

</script>

<svelte:head>
	<title>phanalytics</title>
</svelte:head>

<EvidenceDefaultLayout {data} title="phanalytics 🐟" , hideTOC=true, neverShowQueries=true, hideBreadcrumbs=true>
	<slot slot="content" />
</EvidenceDefaultLayout>