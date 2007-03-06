#ifndef __DELIVER_H
#define __DELIVER_H

#include <sysexits.h>

#include "lib.h"
#include "mail-storage.h"

struct deliver_settings {
	const char *hostname;
	const char *postmaster_address;
	const char *sendmail_path;
};

extern struct deliver_settings *deliver_set;

typedef int deliver_mail_func_t(struct mail_storage *storage, struct mail *mail,
				const char *username, const char *mailbox);

extern deliver_mail_func_t *deliver_mail;

void deliver_env_clean(void);

/* Save a mail into given mailbox with given flags and keywords. */
int deliver_save(struct mail_storage *storage, const char *mailbox,
		 struct mail *mail, enum mail_flags flags,
		 const char *const *keywords);

/* Extracts user@domain from Return-Path header. Returns NULL if not found. */
const char *deliver_get_return_address(struct mail *mail);

/* Returns a new unique Message-ID */
const char *deliver_get_new_message_id(void);

#endif
