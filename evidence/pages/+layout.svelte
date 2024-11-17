<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	export let data;
</script>

<EvidenceDefaultLayout {data} title="phanalytics 🐟" , hideTOC=true, neverShowQueries=true, hideBreadcrumbs=true>
	<slot slot="content" />
</EvidenceDefaultLayout>