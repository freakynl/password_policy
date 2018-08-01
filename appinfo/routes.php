<?php
/**
 *
 * @copyright Copyright (c) 2018, ownCloud GmbH
 * @license GPL-2.0
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

return [
	'routes' => [
		['name' => 'Settings#updatePolicy', 'url' => '/update_policy', 'verb' => 'POST'],
		['name' => 'password#show', 'url' => '/update_password', 'verb' => 'GET'],
		['name' => 'password#update', 'url' => '/update_password', 'verb' => 'POST'],
	],
	'ocs' => [
		[
			'name' => 'NotificationRedirector#markAndRedirectAboutToExpire',
			'url' => '/process_notification/about_to_expire/{id}',
			'verb' => 'POST',
		],
		[
			'name' => 'NotificationRedirector#markAndRedirectExpired',
			'url' => '/process_notification/expired/{id}',
			'verb' => 'POST',
		],
	]
];
