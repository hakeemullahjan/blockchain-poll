import { Web3Service } from './../blockchain/web3.service';
import { Poll, PollForm } from './../types';
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';
import { fromAscii, toAscii } from 'web3-utils';

@Injectable({
  providedIn: 'root',
})
export class PollService {
  constructor(private web3: Web3Service) {}

  async getPolls(): Promise<Poll[]> {
    const polls: Poll[] = [];
    let totalPolls = await this.web3.call('getTotalPolls');

    console.log('total', totalPolls);

    const acc = await this.web3.getAccount();
    const voter = await this.web3.call('getVoter', acc);
    const voterNormalized = this.normalizeVoter(voter);

    for (let i = 0; i < totalPolls; i++) {
      const pollRaw = await this.web3.call('getPoll', i);
      const pollNormalized = this.normalizePoll(pollRaw, voterNormalized);

      polls.push(pollNormalized);
    }

    return polls;
  }

  vote(pollId: number, voteNumber: number) {
    console.log(pollId, voteNumber);
    this.web3.executeTransaction('vote', pollId, voteNumber);
  }

  createPoll(poll: PollForm) {
    console.log(poll);
    this.web3.executeTransaction(
      'createPoll',
      poll.question,
      poll.thumbnails || '',
      poll.options.map((opt) => fromAscii(opt))
    );
  }

  private normalizeVoter(voter) {
    return {
      id: voter[0],
      votedId: voter[1].map((vote) => parseInt(vote)),
    };
  }

  private normalizePoll(pollRaw, voter): Poll {
    return {
      id: parseInt(pollRaw[0]),
      question: pollRaw[1],
      thumbnails: pollRaw[2],
      results: pollRaw[3].map((vote) => parseInt(vote)),
      options: pollRaw[4].map((opt) => toAscii(opt).replace(/\u0000/g, '')),
      voted:
        voter.votedIds &&
        voter.votedIds.find((votedId) => votedId === parseInt(pollRaw[0])) !=
          undefined,
    };
  }

  onEvent(name: string) {
    return this.web3.onEvent(name);
  }
}
