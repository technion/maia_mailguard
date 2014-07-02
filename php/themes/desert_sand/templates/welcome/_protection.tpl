    <div id="protectioncontrol" class="styledform ui-widget-content ui-corner-all">
        {form name="protectionlevel" action="welcome.php$sid"}
         <fieldset>
        <legend>{$lang.text_welcome_current_level}<span>{$lang.radio_protection.$protection}</span></legend>
        <ol>
            <li class="protection_row">
            <select name="protection_level" id="protection_select">
              <option value="off" {if $protection == "off"}selected{/if}>{$lang.radio_protection.off}</option>
              <option value="low" {if $protection == "low"}selected{/if}>{$lang.radio_protection.low}</option>
              <option value="medium" {if $protection == "medium"}selected{/if}>{$lang.radio_protection.medium}</option>
              <option value="high" {if $protection == "high"}selected{/if}>{$lang.radio_protection.high}</option>
            </select>
            </li>
        {if $protection == "custom"}
        <li class="submitrow">
            {$lang.text_welcome_custom_level}
        </li>
        {/if}   
        <li class="protection_row"><input type="submit" name="change_protection" value="{$lang.button_change_protection}"></li>
        </ol>
        </fieldset>
        </form>
        <script type="text/javascript">
        {literal}
          $(function(){
            $('#protection_select').selectToUISlider().hide(); 
            $('#protectioncontrol legend span').hide();
          });
          </script>
        {/literal}
    </div>