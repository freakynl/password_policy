<?php
/**
 * @author Juan Pablo Villafáñez <jvillafanez@solidgear.es>
 * @copyright Copyright (c) 2018, ownCloud GmbH
 * @license GPL-2.0
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License, version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License, version 3,
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 *
 */
namespace OCA\PasswordPolicy;

use OCP\Notification\INotification;
use OCP\Notification\INotifier;
use OCP\Notification\IManager as INotificationManager;
use OCP\AppFramework\Utility\ITimeFactory;
use OCP\L10N\IFactory;
use OC\L10N\L10N;

class Notifier implements INotifier {
	/** @var IFactory */
	protected $factory;

	/** @var ITimeFactory */
	protected $timeFactory;
	/**
	 * @param \OCP\L10N\IFactory $factory
	 */
	public function __construct(
		IFactory $factory,
		ITimeFactory $timeFactory
	) {
		$this->factory = $factory;
		$this->timeFactory = $timeFactory;
	}
	/**
	 * @param INotification $notification
	 * @param string $languageCode The code of the language that should be used to prepare the notification
	 * @return INotification
	 */
	public function prepare(INotification $notification, $languageCode) {
		if ($notification->getApp() !== 'password_policy') {
			throw new \InvalidArgumentException();
		}
		// Read the language from the notification
		$l = $this->factory->get('password_policy', $languageCode);
		switch ($notification->getObjectType()) {
			case 'about_to_expire':
				return $this->formatAboutToExpire($notification, $l);
			case 'expired':
				return $this->formatExpired($notification, $l);
			default:
				throw new \InvalidArgumentException();
		}
	}

	private function formatAboutToExpire(INotification $notification, L10N $l) {
		$params = $notification->getSubjectParameters();
		$notification->setParsedSubject(
			(string) $l->t('Your password is about to expire!', $params)
		);

		$messageParams = $notification->getMessageParameters();
		$currentTime = $this->timeFactory->getTime();
		$currentDateTime = new \DateTime("@{$currentTime}");
		$passwordTime = $messageParams[0];
		$expirationTime = $messageParams[1];
		$targetExpirationTime = $passwordTime + $expirationTime;
		$expirationDateTime = new \DateTime("@{$targetExpirationTime}");
		$interval = $currentDateTime->diff($expirationDateTime);

		if ($interval->invert) {
			$notification->setParsedMessage(
				(string) $l->t('Your password has already expired %1$s days ago', [$interval->days])
			);
		} else {
			$notification->setParsedMessage(
				(string) $l->t('You have %1$s days to change your password', [$interval->days])
			);
		}

		foreach ($notification->getActions() as $action) {
			switch ($action->getLabel()) {
				case 'Change password':
					$action->setParsedLabel(
						(string) $l->t('Change Password')
					);
					break;
			}

			$notification->addParsedAction($action);
		}

		return $notification;
	}

	private function formatExpired(INotification $notification, L10N $l) {
		$params = $notification->getSubjectParameters();
		$notification->setParsedSubject(
			(string) $l->t('Your password has expired', $params)
		);

		$messageParams = $notification->getMessageParameters();

		$notification->setParsedMessage(
			(string) $l->t('You have to change your password before you can access again', $messageParams)
		);

		foreach ($notification->getActions() as $action) {
			switch ($action->getLabel()) {
				case 'Change password':
					$action->setParsedLabel(
						(string) $l->t('Change Password')
					);
					break;
			}

			$notification->addParsedAction($action);
		}

		return $notification;
	}
}