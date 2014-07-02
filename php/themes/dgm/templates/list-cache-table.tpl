<div class="cache-table panel1 outy"> <!-- cache listing -->
      
        {section name=hamloop loop=$row}
        {strip}
		{capture assign="poptext"}
		From:&nbsp;&nbsp;&nbsp;&nbsp;{$row[hamloop].sender_email}<br>
		To:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{foreach from=$row[hamloop].recipient_email item=recip_to}
		{$recip_to}<br> {* DGM FIXME need to loop here *}
		{/foreach}
		Date:&nbsp;&nbsp;&nbsp;&nbsp;{$row[hamloop].received_date}<br>
		Subject:&nbsp;{$row[hamloop].subject}
		{/capture} 
        <div class="cache_row inny {$cache_type}1" {popup text=$poptext snapx="30" snapy="30"}><!-- cache_row -->
        <div class="cache_score c_score"> 
            {$row[hamloop].score|string_format:"%0.1f"}
        </div>
        <div class="cache_received c_received">
            {$row[hamloop].received_date|truncate:20:"...":true|escape}
        </div>
        <div class="cache_sender c_sender" align="center">
            {$row[hamloop].sender_email|truncate:20:"...":true|escape}
        </div>
        
		{count var=$row[hamloop].recipient_email assign="count"}
        <div class="cache_recipient c_recipient" align="center">
        {if $count == 1}
           {$row[hamloop].recipient_email[0]|truncate:20:"...":true|escape}
        {else}
            Multiple recipients
        {/if}
        </div>
    
        <div class="cache_subject" align="left">
            <a href="view.php{$msid}id={$row[hamloop].id}&amp;cache_type={$cache_type}" class="c_subject">
                {$row[hamloop].subject|truncate:29:"...":true|escape}
            </a>
        </div>
    
    {*    <div class="cache_spam"> DGM FIXME is this needed?
            This is Spam! <input type="checkbox" class="spam" name="item_{$row[hamloop].id}" value="spam">
        </div>
        <div class="cache_ham">
            {$lang.text_ham}<input type="radio" class="ham" name="item_{$row[hamloop].id}" value="ham" checked>
        </div>
        <div class="cache_delete">
            {$lang.text_delete}<input type="radio" class="delete" name="item_{$row[hamloop].id}" value="delete">
        </div>
     *}   
        <div class="cache_select">
            <input type="checkbox" class="cachecheck" name="cache_item[generic][{$row[hamloop].id}]" value="{$row[hamloop].id}">
        </div>
      </div> <!-- cache row -->
    {/strip}
    
    {/section}
</div>
