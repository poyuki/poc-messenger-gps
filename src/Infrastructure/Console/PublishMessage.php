<?php

declare(strict_types=1);

namespace App\Infrastructure\Console;

use App\Infrastructure\Messenger\Message\Test;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Messenger\MessageBusInterface;

class PublishMessage extends Command
{
    protected static $defaultName = 'publish';

    public function __construct(private MessageBusInterface $messageBus)
    {
        parent::__construct(self::$defaultName);
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $this->messageBus->dispatch(Test::create());

        return parent::SUCCESS;
    }
}
