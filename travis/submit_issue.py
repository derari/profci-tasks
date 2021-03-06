#!/usr/bin/env python2.7

import logging, os, sys, json
from github3 import GitHub
from requests import get

logging.basicConfig(level=logging.DEBUG)
logging.getLogger('github3').setLevel(logging.WARNING)
log = logging.getLogger(__name__)

# Load json from Rspec run from stdin
input = sys.stdin.read()
try:
	test_runs = json.loads(input)
except:
	print input
	raise
# As Rspec should be run in --fail-fast mode, the last 
# run test should be the one that failed
failed_test = test_runs['examples'][-1]

status = failed_test['status']
if status != 'failed':
	log.error('Last test did not fail!')
	log.error(failed_test)
	sys.exit(1)

title = failed_test['full_description']
body = failed_test['exception']['message']
log.debug("Failed test: {test}".format(test=title))

# Create Github issue
gh_username = 'swt2public'
gh_password = 'wnjxeUn6pQpcnR4V'

log.debug("Logging in as {user}".format(user=gh_username))
github = GitHub(gh_username, gh_password)
log.debug("Ratelimit remaining: {rate}".format(rate=github.ratelimit_remaining))

# create_issue(owner, repository, title, body=None, assignee=None, milestone=None, labels=[])
# TRAVIS_REPO_SLUG (owner_name/repo_name)
# https://docs.travis-ci.com/user/environment-variables/
owner, repo = os.environ.get('TRAVIS_REPO_SLUG').split('/')
log.debug("Repo: {owner}/{repo}".format(owner=owner, repo=repo))

found = False

# If there is already an open issue, create a comment instead of a new issue
for issue in github.iter_repo_issues(owner, repo, state='open'):
	if issue.title == title:
		log.debug("Found existing open ticket: {url}".format(url=issue.html_url))
		comment = issue.create_comment(body)
		log.debug("Created comment: {comment}".format(comment=comment))
		found = True
		break

if not found:
	log.debug("Attempting to create issue...")
	resp = github.create_issue(owner, repo, title, body, owner)
	log.debug("Created ticket: {resp}".format(resp=resp))

# Determine score
example_count = test_runs['summary']['example_count']
failure_count = test_runs['summary']['failure_count'] # should be 1
score = example_count - failure_count

# # Post results -- do not post results in this version
# log.debug("Attempting to post score ({score})...".format(score=score))
# url = "https:   "
# resp = get(url.format(owner=owner, repo=repo, score=score))
# log.debug("TDD-chart response: {code}".format(code=resp.status_code))
