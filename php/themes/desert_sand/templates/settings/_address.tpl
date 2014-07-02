<div id="address_settings"  class="styledform ui-widget-content">
  {form action="xsettings.php$sid" name="settings"}
  <input type="hidden" name="address_id" value="{$address_id}">
  <fieldset>
<legend>{$lang.header_address}: {$address}</legend>
<ol>

      {assign var="atleastone" value="1"}
<li class="virusbody2">
  <label>{$lang.text_virus_scanning}</label>
  {if $user_virus_scanning}
<input type="radio" name="viruses" value="yes" {$bv_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="viruses" value="no" {$bv_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
  {else}
    {if $bv_y_checked}
      {$lang.text_enabled}
    {else}
      {$lang.text_disabled}
    {/if}
  {/if}
</li>



<li class="virusbody2">
<label>{$lang.text_detected_viruses}</label>
<input type="radio" name="virus_destiny" value="label" {$v_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="virus_destiny" value="quarantine" {$v_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="virus_destiny" value="discard" {$v_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</li>

<li class="spambody2">
  <label>{$lang.text_spam_filtering}</label>
  {if $user_spam_filtering}
<input type="radio" name="spam" value="yes" {$bs_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="spam" value="no" {$bs_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
  {else}
    {if $bs_y_checked}
      {$lang.text_enabled}
    {else}
      {$lang.text_disabled}
    {/if}
  {/if}
</li>

<li class="spambody2">
<label>{$lang.text_detected_spam}</label>
<input type="radio" name="spam_destiny" value="label" {$s_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="spam_destiny" value="quarantine" {$s_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="spam_destiny" value="discard" {$s_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</li>

<li class="spambody2">
<label>{$lang.text_prefix_subject}?</label>
<input type="radio" name="modify_subject" value="yes" {$sms_y_checked}>&nbsp;{$lang.text_yes}&nbsp;&nbsp;
<input type="radio" name="modify_subject" value="no" {$sms_n_checked}>&nbsp;{$lang.text_no}&nbsp;&nbsp;
</li>

<li class="spambody2">
<label>{$lang.text_add_spam_header} >= </label>
<input type=text size=7 name=level1 value="{$level1|string_format:"%1.3f"}">
</li>

<li class="spambody2">
<label>{$lang.text_consider_mail_spam} >= </label>
<input type=text size=7 name=level2 value="{$level2|string_format:"%1.3f"}">
</li>

<li class="spambody2">
<label>{$lang.text_quarantine_spam} >= </label>
<input type=text size=7 name=level3 value="{$level3|string_format:"%1.3f"}">
</li>

<li class="banned_filebody2">
<label>{$lang.text_attachment_filtering}</label>
  {if $user_banned_files_checking}
<input type="radio" name="banned" value="yes" {$bb_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="banned" value="no" {$bb_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
  {else}
    {if $bb_y_checked}
      {$lang.text_enabled}
    {else}
      {$lang.text_disabled}
    {/if}
  {/if}
</li>

<li class="banned_filebody2">
<label>{$lang.text_mail_with_attachments}</label>
<input type="radio" name="banned_destiny" value="label" {$b_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="banned_destiny" value="quarantine" {$b_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="banned_destiny" value="discard" {$b_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</li>

<li class="bad_headerbody2">
  <label>{$lang.text_bad_header_filtering}</label>
  {if $user_bad_header_checking}
<input type="radio" name="headers" value="yes" {$bh_y_checked}>&nbsp;{$lang.text_enabled}&nbsp;&nbsp;
<input type="radio" name="headers" value="no" {$bh_n_checked}>&nbsp;{$lang.text_disabled}&nbsp;&nbsp;
  {else}
    {if $bh_y_checked}
      {$lang.text_enabled}
    {else}
      {$lang.text_disabled}
    {/if}
  {/if}
</li>

<li class="bad_headerbody2"><label>{$lang.text_mail_with_bad_headers}</label>
<input type="radio" name="headers_destiny" value="label" {$h_l_checked}>&nbsp;{$lang.text_labeled}&nbsp;&nbsp;
<input type="radio" name="headers_destiny" value="quarantine" {$h_q_checked}>&nbsp;{$lang.text_quarantined}&nbsp;&nbsp;
<input type="radio" name="headers_destiny" value="discard" {$h_d_checked}>&nbsp;{$lang.text_discarded}&nbsp;&nbsp;
</li>

<li class="submitrow">
<input type="submit" name="upone" value=" {$lang.button_update_address} ">&nbsp;&nbsp;
{if !$domain_user}<input type="submit" name="upall" value="{$lang.button_update_all_addresses}">&nbsp;&nbsp;{/if}
<input type="reset" name="reset" value="{$lang.button_reset}">
</li>
</ol>
</fieldset>
</form>
</div>

