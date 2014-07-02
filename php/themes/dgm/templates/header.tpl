
{if $use_logo}
<div class="logo">
    {if $logo_url}
        <a href="{$logo_url}" onmouseover="show_tooltip(this, event, '{$logo_alt_text}')" onmouseout="hide_tooltip()">
    {/if}
        <img src="{$template_dir}{$logo_file}" id="logo" border="0" alt="{$logo_alt_text}" width="{$logo_width}" height="{$logo_height}">
    {if $logo_url}
        </a>
    {/if}
</div>
{/if}

