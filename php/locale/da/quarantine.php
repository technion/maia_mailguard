<?php
    /*
     * $Id$
     *
     * MAIA MAILGUARD LICENSE v.1.0
     *
     * Copyright 2004 by Robert LeBlanc <rjl@renaissoft.com>
     * All rights reserved.
     *
     * PREAMBLE
     *
     * This License is designed for users of Maia Mailguard
     * ("the Software") who wish to support the Maia Mailguard project by
     * leaving "Maia Mailguard" branding information in the HTML output
     * of the pages generated by the Software, and providing links back
     * to the Maia Mailguard home page.  Users who wish to remove this
     * branding information should contact the copyright owner to obtain
     * a Rebranding License.
     *
     * DEFINITION OF TERMS
     *
     * The "Software" refers to Maia Mailguard, including all of the
     * associated PHP, Perl, and SQL scripts, documentation files, graphic
     * icons and logo images.
     *
     * GRANT OF LICENSE
     *
     * Redistribution and use in source and binary forms, with or without
     * modification, are permitted provided that the following conditions
     * are met:
     *
     * 1. Redistributions of source code must retain the above copyright
     *    notice, this list of conditions and the following disclaimer.
     *
     * 2. Redistributions in binary form must reproduce the above copyright
     *    notice, this list of conditions and the following disclaimer in the
     *    documentation and/or other materials provided with the distribution.
     *
     * 3. The end-user documentation included with the redistribution, if
     *    any, must include the following acknowledgment:
     *
     *    "This product includes software developed by Robert LeBlanc
     *    <rjl@renaissoft.com>."
     *
     *    Alternately, this acknowledgment may appear in the software itself,
     *    if and er blevetver such third-party acknowledgments normally appear.
     *
     * 4. At least one of the following branding conventions must be used:
     *
     *    a. The Maia Mailguard logo appears in the page-top banner of
     *       all HTML output pages in an unmodified form, and links
     *       directly to the Maia Mailguard home page; or
     *
     *    b. The "Poer blevetd by Maia Mailguard" graphic appears in the HTML
     *       output of all gateway pages that lead to this software,
     *       linking directly to the Maia Mailguard home page; or
     *
     *    c. A separate Rebranding License is obtained from the copyright
     *       owner, exempting the Licensee from 4(a) and 4(b), subject to
     *       the additional conditions laid out in that license document.
     *
     * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS
     * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
     * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
     * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
     * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
     * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
     * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
     * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
     * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
     * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
     * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
     *
     */

    // Page subtitle
    $lang['banner_subtitle'] =  "Karantæne område";

    // Table headers
    $lang['header_spam'] =  "Formodet spam";
    $lang['header_viruses'] =  "Vira/Skadelig software";
    $lang['header_banned_files'] =  "Blokerede filvedhæng";
    $lang['header_bad_headers'] =  "Ukorrekte mail headere";
    $lang['header_quarantine_contents'] =  "Karantæne indhold";

    // Text labels
    $lang['text_item'] =  "Email";
    $lang['text_emails'] =  "Emails";
    $lang['text_score'] =  "Score";
    $lang['text_received'] =  "Modtaget";
    $lang['text_from'] =  "Fra";
    $lang['text_to'] =  "Til";
    $lang['text_ham'] =  "Ikke-spam?";
    $lang['text_spam'] =  "Spam?";
    $lang['text_rescue'] =  "Ikke-spam!";
    $lang['text_delete'] =  "Slet";
    $lang['text_subject'] =  "Emne";
    $lang['text_virus'] =  "Virus";
    $lang['text_file_name'] =  "Fil Navn";
    $lang['text_no_subject'] =  "intet emne";
    $lang['text_empty'] =  "Dit karantæne område er tomt.";
    $lang['text_updated'] =  "Dit karantæne område er blevet opdateret.";
    $lang['text_of'] =  "af";
    $lang['text_spam_confirmed'] =  "%d formodet spam emails er blevet bekræftet";
    $lang['text_spam_reddet'] =  "%d formodet spam emails er blevet reddet";
    $lang['text_spam_slettet'] =  "%d formodet spam emails er blevet slettet";
    $lang['text_viruses_reddet'] =  "%d virus/malware emails er blevet reddet";
    $lang['text_viruses_slettet'] =  "%d virus/malware emails er blevet slettet";
    $lang['text_attachments_reddet'] =  "%d banned file attachments er blevet reddet";
    $lang['text_attachments_slettet'] =  "%d banned file attachments er blevet slettet";
    $lang['text_headers_reddet'] =  "%d corrupt e-mails er blevet reddet";
    $lang['text_headers_slettet'] =  "%d corrupt e-mails er blevet slettet";
    $lang['text_formodet_spam_item'] =  "Formodet spam email";
    $lang['text_formodet_spam_emails'] =  "Formodet spam emails";
    $lang['text_virus_item'] =  "Virus/Skadelig software email";
    $lang['text_virus_emails'] =  "Virus/Skadelig software emails";
    $lang['text_banned_file_item'] =  "Blokerede filvedhæng";
    $lang['text_banned_file_emails'] =  "Blokerede filvedhæng";
    $lang['text_bad_header_item'] =  "Ødelagt email";
    $lang['text_bad_header_emails'] =  "Ødelagt email";
    $lang['text_rescue_error'] = "Kunne ikke redde email: ";

    // Button text
    $lang['button_confirm_spam'] =  "ALLE emails på denne liste er spam";
    $lang['button_delete_viruses'] =  "Slet disse Vira";
    $lang['button_delete_attachments'] =  "Slet disse filer";
    $lang['button_delete_headers'] =  "Slet disse ødelagte emails";
    $lang['button_confirm'] =  "Bekræft status på disse emails";
    $lang['button_delete_all_emails'] =  "Slet ALLE emails i karantæne";

    // Link text
    $lang['link_prev'] =  "Forrige";
    $lang['link_next'] =  "Næste";
    $lang['link_quarantine'] =  "Tilbage til karantæne menuen";
    $lang['link_welcome']  = "Tilbage til velkomst siden";

?>
